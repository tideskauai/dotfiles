-- haskell
import Data.List -- (6)

import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import System.Exit

-- utilities
import XMonad.Util.Run --to use safespawn
import XMonad.Util.WorkspaceCompare --to use getSortByIndex in ppSort
import XMonad.Util.Scratchpad --to use scratchpadFilterOutWorkspace&scratchpad
import XMonad.Util.EZConfig --easy M-key like bindings

-- actions and prompts
import XMonad.Actions.GridSelect
import XMonad.Actions.CycleWS --toggleWS (5)
import XMonad.Actions.CopyWindow --copy win to workspaces (2)
import XMonad.Actions.FocusNth --focus nth window in current workspace (3)
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.AppendFile
import qualified XMonad.Prompt         as P
import qualified XMonad.Actions.Submap as SM
import qualified XMonad.Actions.Search as S

-- hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.InsertPosition -- position and focus for new windows (4)

-- layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Named
import XMonad.Layout.Reflect

-- local libs
import DynamicTopic -- (1)

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
                           , workspaces    = myWorkspaces
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
myTerminal      = "urxvt"
myBorderWidth   = 1
myModMask = mod4Mask

-- urgent notification
urgentConfig = UrgencyConfig { suppressWhen = Focused, remindWhen = Dont }

--hooks
myManageHook :: ManageHook
myManageHook = (composeAll . concat $
            [[ className =? "Firefox"    --> doShift "web"
            , className =? "Chromium"   --> insertPosition End Older <+> doShift "web" -- (4)
            , className =? "Pavucontrol" --> insertPosition End Older <+> doShift "im" -- (4)
            , className =? "Pidgin" --> insertPosition End Older <+> doShift "im" -- (4)
            , fmap ("LibreOffice" `isInfixOf`) className --> doShift "doc" -- (6)
            , className =? "Epdfview"   --> doShift "doc"
            , className =? "Okular"   --> doShift "doc"
            , className =? "VirtualBox" --> doShift "8"
            , className =? "MPlayer"    --> doShift "8"
            , className =? "mplayer2"    --> doShift "8"
            , className =? "Vlc"    --> doShift "8"
            , className =? "Hamster-time-tracker" --> doShift "NSP"
            , className =? "Osmo" --> doShift "NSP"
            , className =? "Skype" --> doShift "NSP"
            , className =? "trayer" --> doIgnore
            , className =? "URxvt" --> insertPosition Below Newer -- (4)
            , className =? "Gtkdialog" --> doFloat
            , className =? "V4l2ucp" --> doFloat
            , className =? "Firefox" <&&> resource =? "Download" --> doFloat
            , fmap ("Call with" `isInfixOf`) title --> doFloat -- (6)
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

--topics or workspaces
myWorkspaces :: [WorkspaceId]
myWorkspaces = [ "web", "im", "dev", "doc", "5", "6", "7", "8", "9", "NSP"]

--layouts
myLayout = customLayout
customLayout =  onWorkspace "web" fsLayout $
                onWorkspace "im" imLayout $
                onWorkspace "dev" devLayout $
                onWorkspace "doc" fsLayout $
                onWorkspace "8" fsLayout $
                standardLayouts
    where
    standardLayouts = tiled ||| Mirror tiled ||| full

    rt = ResizableTall 1 (2/100) (1/2) []
    tiled = named "[]=" $ smartBorders rt    
    mtiled = named "M[]=" $ smartBorders $ Mirror rt
    rmtiled = named "RM[]=" $ noBorders $ reflectVert mtiled
    full = named "[]" $ noBorders Full
    
    fsLayout = full ||| tiled
    imLayout = full ||| rmtiled
    devLayout = full ||| rmtiled

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
    [ ((0, xK_d), method S.dictionary)
    , ((0, xK_t), method S.thesaurus)
    , ((0, xK_w), method $ S.searchEngine "wordReference" "http://www.wordreference.com/es/translation.asp?tranword=")
    , ((0, xK_b), method $ S.searchEngine "BBS" "http://bbs.archlinux.org/search.php?action=search&sort_dir=DESC&keywords=")
    , ((0, xK_a), method $ S.searchEngine "archwiki" "http://wiki.archlinux.org/index.php/Special:Search?search=")
    , ((0, xK_q), method $ S.searchEngine "duckduckgo" "https://duckduckgo.com/?q=")
    ]


toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)
myKeys conf = mkKeymap conf $ [
    --Making Caps Lock useful, editing of ~/.xmodmap required
      ("M3-<Return>", scratchpadSpawnAction defaultConfig  {terminal = myTerminal})
    , ("M3-s", toggleWS' ["NSP"]) -- toggle between workspaces (5)
    , ("M3-f", focusUrgent) -- go to urgent window
    , ("M3-q", SM.submap $ searchEngineMap $ S.promptSearch myXPConfig) --query the web
    , ("M3-k", killAllOtherCopies) -- Kill all copied windows (2)
    , ("M3-=", safeSpawn "amixer" ["-q","set","Master","toggle"])
    , ("M3-0", safeSpawn "amixer" ["-c0","set","Beep", "toggle"])
    , ("M3--", safeSpawn "amixer" ["-q","set","Master","4%-"])
    , ("M3-S--", safeSpawn "amixer" ["-q","set","Master","4%+"])
    , ("M3-l", safeSpawn "xlock" ["-mode","blank","-geometry","1x1"])
    , ("M3-z", goToSelected defaultGSConfig { gs_cellwidth = 250 })
    --Making Ctrl_R useful, editing of ~/.xmodmap required
    , ("M5-<Return>", changeDir myXPConfig) --change the dir of the topic (1)
    , ("M5-=", safeSpawn "ncmpcpp" ["toggle"])
    , ("M5--", safeSpawn "ncmpcpp" ["next"])
    , ("M5-S--", safeSpawn "ncmpcpp" ["prev"])
    , ("M5-f", safeSpawn "firefox" [])
    , ("M5-S-f", safeSpawn "pcmanfm" [])
    , ("M5-S-v", safeSpawn "VirtualBox" [])
    , ("M5-c", safeSpawn "chromium" ["--incognito"])
    , ("M5-w", safeSpawn "v4l2-ctl" ["-c", "exposure_auto=1", "-c", "exposure_absolute=22"])
    , ("M5-t", safeSpawn "osmo" [] >> safeSpawn "hamster-time-tracker" [])
    , ("M5-p", safeSpawn "pavucontrol" [])
    , ("M5-q", SM.submap $ searchEngineMap $ S.selectSearch) --query the web(selected text)
    
    --launching
    , ("M-<Return>", spawnShell) -- launch shell in topic (1)
    , ("M-p", shellPrompt myXPConfig)
    , ("M-x", safeSpawn "bash" ["/home/shivalva/.config/owncfg/clipsync/dmenu.sh"])
    , ("M-S-x", safeSpawn "python" ["/home/shivalva/.config/owncfg/clipsync/sync.py"])
    , ("M-z", appendFilePrompt myXPConfig "/home/shivalva/Archives/txt/NOTES")
    
    --killing
    , ("M-S-c", kill)
    
    --layouts
    , ("M-<Space>", sendMessage NextLayout)
    , ("M-S-<Space>", sendMessage FirstLayout)
    
    --floating layer stuff
    , ("M-t", withFocused $ windows . W.sink)
    
    --focus
    , ("M-<Tab>", windows W.focusDown)
    
    --swapping
    , ("M-S-<Return>", windows W.shiftMaster)
    , ("M-S-j", windows W.swapDown  )
    , ("M-S-k", windows W.swapUp    )
    
    
    --resizing
    , ("M-h", sendMessage Shrink)
    , ("M-l", sendMessage Expand)
    , ("M-j", sendMessage MirrorShrink)
    , ("M-k", sendMessage MirrorExpand)
    , ("M-,", sendMessage (IncMasterN 1)) -- inc win # in master area
    , ("M-.", sendMessage (IncMasterN (-1))) -- dec win # in master area
    
    --quit, or restart
    , ("M-S-e", io (exitWith ExitSuccess)) -- exit WM
    , ("M-S-r", restart "xmonad" True) -- restart WM
    ]

    -- mod-[1..9],       Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    -- mod3-[1..9],      Copy windows to workspace N (1)
    ++ [(m ++ k, windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) $ map show [1..9]
        , (f, m) <- [(W.greedyView, "M-"), (W.shift, "M-S-"), (copy, "M3-")]
    ]
    -- mod5-[1..9],     Switch to window N (3)
    ++ [(("M5-" ++ show k), focusNth i)
        | (i, k) <- zip [0 .. 8] [1..9]
    ]
