import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import System.Exit

-- utilities
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.WorkspaceCompare --to use getSortByIndex in ppSort
import XMonad.Util.Scratchpad --to use scratchpadFilterOutWorkspace&scratchpad

-- actions and prompts
import XMonad.Actions.GridSelect
import XMonad.Actions.CycleWS
import XMonad.Actions.CopyWindow --copy win to all workspaces
import XMonad.Actions.TopicSpace --change working directory
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.AppendFile
import qualified XMonad.Prompt         as P
import qualified XMonad.Actions.Submap as SM
import qualified XMonad.Actions.Search as S

-- hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.InsertPosition

-- layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Named
import XMonad.Layout.Reflect

-------------------------------------------------------------------------------
---- Main ---
-------------------------------------------------------------------------------
main :: IO ()
main = xmonad =<< statusBar cmd pp kb conf
    where
        uhook = withUrgencyHookC NoUrgencyHook urgentConfig
        cmd = "bash -c \"tee >(xmobar -x0) | xmobar -x1\""
        pp = myPP
        kb = toggleStrutsKey
        conf = uhook myConfig

-------------------------------------------------------------------------------
--- Configs ---
-------------------------------------------------------------------------------
myConfig = defaultConfig { focusFollowsMouse = False
                           , terminal      = myTerminal
                           , workspaces    = myTopics
                           , modMask       = myModMask
                           , borderWidth   = myBorderWidth
                           , normalBorderColor = colorNormalBorder 
                           , focusedBorderColor = colorFocusedBorder
                           , keys = myKeys
                           , layoutHook = myLayout
                           , manageHook = myManageHook
                         }

-- Declarations
colorBlack      = "#000000"
colorBlackAlt   = "#040404"
colorGray       = "#444444"
colorGrayAlt    = "#282828"
colorDarkGray   = "#161616"
colorWhite      = "#cfbfad"
colorWhiteAlt   = "#8c8b8e"
colorDarkWhite  = "#606060"
colorCream      = "#a9a6af"
colorDarkCream  = "#5f656b"
colorMagenta    = "#a488d9"
colorMagentaAlt = "#7965ac"
colorDarkMagenta= "#8e82a2"
colorBlue       = "#98a7b6"
colorBlueAlt    = "#598691"
colorDarkBlue   = "#464a4a"
colorGranate    = "#410039"
colorPink       = "#ff6ffa"
colorNormalBorder   = colorDarkGray
colorFocusedBorder  = colorGranate
myTerminal      = "urxvtc"
myBorderWidth   = 1
myModMask = mod4Mask

-- urgent notification
urgentConfig = UrgencyConfig { suppressWhen = Focused, remindWhen = Dont }

--hooks
myManageHook :: ManageHook
myManageHook = (composeAll . concat $
            [[ className =? "Firefox"    --> doShift "web"
            , className =? "Chromium"   --> doShift "web"
            , className =? "Pavucontrol" --> doShift "im"
            , className =? "Pidgin" --> doShift "im"
            , className =? "Skype" --> doShift "im"
            , className =? "Epdfview"   --> doShift "doc"
            , className =? "VirtualBox" --> doShift "8"
            , className =? "MPlayer"    --> doShift "8"
            , className =? "Vlc"    --> doShift "8"
            , className =? "Hamster-time-tracker" --> doShift "NSP"
            , className =? "trayer" --> doIgnore
            , className =? "URxvt" --> insertPosition Below Newer
            , className =? "Gtkdialog" --> doFloat
            , className =? "V4l2ucp" --> doFloat
            , className =? "Firefox" <&&> resource =? "Download" --> doFloat
            , title =? "Skype Full-Screen Video" --> doFloat
            ]]) <+> manageScratchPad

manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect (1/4) (1/4) (1/2) (1/2))


--bar looks (xmobar)
myPP = xmobarPP { ppCurrent = xmobarColor colorBlueAlt ""
                  , ppTitle =  shorten 50
                  , ppSep =  " <fc=#a488d9>:</fc> "
                  , ppUrgent = xmobarColor "" colorPink
                  , ppSort = fmap (.scratchpadFilterOutWorkspace) getSortByIndex
                }

--topics
myTopics :: [Topic]
myTopics = [ "web", "im", "dev", "doc", "5", "6", "7", "8", "9", "NSP"]

myTopicConfig :: TopicConfig
myTopicConfig = defaultTopicConfig
                { topicDirs = M.fromList $ [ ("web", "~/Downloads")
                                           , ("im", "~/Downloads")
                                           , ("dev", "~/dev")
                                           , ("doc", "~/Archives/eLearn")
                                           , ("8", "~/Downloads/torrente/multimedia")
                                           ]
                , defaultTopicAction = const $ spawnShell >*> 1
                , topicActions = M.fromList $ [ ("web", spawn "firefox")
                                              , ("im", spawn "skype" >> spawn "pavucontrol" >> spawn "v4l2ucp")
                                              , ("8", spawn "VirtualBox")
                                              , ("9", spawn "urxvtc -e ssh eee")
                                              ]
                }

spawnShell :: X ()
spawnShell = currentTopicDir myTopicConfig >>= spawnShellIn

spawnShellIn :: Dir -> X ()
spawnShellIn dir = asks (terminal . config) >>= \t -> spawn $ "cd " ++ dir ++ " && exec " ++ t

--layouts
myLayout = customLayout
customLayout =  onWorkspace "web" fsLayout $
                onWorkspace "im" imLayout $
                onWorkspace "doc" fsLayout $
                onWorkspace "8" fsLayout $
                standardLayouts
    where
    standardLayouts = tiled ||| (Mirror tiled) ||| full

    rt = ResizableTall 1 (2/100) (1/2) []
    tiled = named "[]=" $ smartBorders rt    
    mtiled = named "M[]=" $ smartBorders $ Mirror rt
    full = named "[]" $ noBorders Full
    
    fsLayout = full ||| tiled
    imLayout = reflectVert $ mtiled ||| full

--prompt theme
myXPConfig = defaultXPConfig {  font = "terminus"
                                , fgColor           = colorDarkMagenta
                                , bgColor           = colorDarkGray
                                , bgHLight          = colorMagenta
                                , fgHLight          = colorDarkGray
                                , borderColor       = colorBlackAlt
                                , promptBorderWidth = 1
                                , height = 18
                                , position = Bottom
                                , historySize = 100
                                , historyFilter = deleteConsecutive
                             }

-------------------------------------------------------------------------------
--- Keys ---
-------------------------------------------------------------------------------
--Search the web: M + q + search engine
searchEngineMap method = M.fromList $
    [ ((0, xK_q), method S.multi)
    , ((0, xK_d), method S.dictionary)
    , ((0, xK_t), method S.thesaurus)
    , ((0, xK_w), method $ S.searchEngine "wordReference" "http://www.wordreference.com/es/translation.asp?tranword=")
    , ((0, xK_b), method $ S.searchEngine "BBS" "http://bbs.archlinux.org/search.php?action=search&sort_dir=DESC&keywords=")
    , ((0, xK_a), method $ S.searchEngine "archwiki" "http://wiki.archlinux.org/index.php/Special:Search?search=")
    ]


toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    --launching
    [ ((modm,               xK_Return), spawnShell) -- launch shell in topic
    , ((modm,               xK_p), shellPrompt myXPConfig)
    , ((modm,               xK_x), spawn "sh ~/.config/owncfg/clipsync/dmenu.sh")
    , ((modm .|. shiftMask, xK_x), spawn "python2 ~/.config/owncfg/clipsync/sync.py")
    , ((modm,               xK_z), appendFilePrompt myXPConfig "/home/shivalva/.config/owncfg/txt/NOTES")
    
    --Making Caps Lock useful
    --editing of .xmodmap is required
    -- launch topic action
    , ((mod3Mask, xK_BackSpace), currentTopicAction myTopicConfig)
    -- scratchpad
    , ((mod3Mask, xK_Return), scratchpadSpawnAction defaultConfig  {terminal = myTerminal})
    , ((mod3Mask, xK_s), toggleWS) -- toggle between workspaces
    , ((mod3Mask, xK_f), focusUrgent) -- go to urgent window
    , ((mod3Mask, xK_z), goToSelected defaultGSConfig { gs_cellwidth = 250 })
    , ((mod3Mask, xK_q), SM.submap $ searchEngineMap $ S.promptSearch myXPConfig) --query the web
    , ((mod3Mask .|. shiftMask, xK_q), SM.submap $ searchEngineMap $ S.selectSearch) --query the web
    , ((mod3Mask, xK_minus), spawn "ncmpcpp prev"  ) -- prev song in ncmpcpp
    , ((mod3Mask, xK_equal), spawn "ncmpcpp next"  ) -- next song in ncmpcpp
    , ((mod3Mask, xK_0), spawn "ncmpcpp toggle"  ) -- toggle song in ncmpcpp
    , ((mod3Mask, xK_v ), windows copyToAll) -- Make focused window always visible
    , ((mod3Mask .|. shiftMask, xK_v ),  killAllOtherCopies) -- Toggle window state back
    
    --Multimedia extra keys
    , ((0, 0x1008ff1d), spawn "xlock -mode blank -geometry 1x1" ) -- lock screen
    , ((0, 0x1008ff2f), spawn "pwrman suspend" ) -- suspend computer
    , ((0, 0x1008ff12), spawn "amixer -q set Master toggle"  ) -- toggle mute
    , ((0, 0x1008ff11), spawn "amixer -q set Master 1%-"  ) -- vol down 
    , ((0, 0x1008ff13), spawn "amixer -q set Master 1%+"  ) -- vol up
    
    --killing
    , ((modm .|. shiftMask, xK_c     ), kill)
    
    --layouts
    , ((modm,               xK_space ), sendMessage NextLayout)
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    
    --floating layer stuff
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    
    --refresh
    , ((modm,               xK_n     ), refresh)
    
    --focus
    , ((modm,               xK_Tab   ), windows W.focusDown)
    , ((modm,               xK_j     ), windows W.focusDown)
    , ((modm,               xK_k     ), windows W.focusUp)
    , ((modm,               xK_m     ), windows W.focusMaster)
    
    --swapping
    , ((modm .|. shiftMask, xK_Return), windows W.shiftMaster)
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
    
    --increase or decrease number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    
    --resizing
    , ((modm,               xK_h     ), sendMessage Shrink)
    , ((modm,               xK_l     ), sendMessage Expand)
    , ((modm .|. shiftMask, xK_h     ), sendMessage MirrorShrink)
    , ((modm .|. shiftMask, xK_l     ), sendMessage MirrorExpand)
    
    --quit, or restart
    , ((modm .|. shiftMask, xK_q), io (exitWith ExitSuccess))
    , ((modm              , xK_q), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++
     -- mod-[1..9] %! Switch to workspace N
     -- mod-shift-[1..9] %! Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    -- mod-[w,e] %! switch to twinview screen 1/2
    -- mod-shift-[w,e] %! move window to screen 1/2
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_e, xK_w] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
