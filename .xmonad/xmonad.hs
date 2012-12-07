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
import XMonad.Actions.GroupNavigation --toggle between windows (6)
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
        --Command to launch the bar
        cmd = "bash -c \"tee >(xmobar -x0) | xmobar -x1\""
        --Custom pp, determines what is being written to the bar
        pp = myPP
        --Keybinding to toggle the gap for the bar
        kb = toggleStrutsKey
        --Main configuration
        conf = uhook myConfig

-------------------------------------------------------------------------------
--- xmobar various settings ---
-------------------------------------------------------------------------------
--Urgent notification
urgentConfig = UrgencyConfig { suppressWhen = Focused, remindWhen = Dont }
--Looks settings
myPP = xmobarPP { ppCurrent = xmobarColor colorBlueAlt ""
                  , ppTitle =  shorten 50
                  , ppSep =  " <fc=#a488d9>:</fc> "
                  , ppUrgent = xmobarColor "" colorPink
                  , ppSort = fmap (.scratchpadFilterOutWorkspace) getSortByIndex
                }
--Toggle key
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

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
                           , logHook = historyHook -- (6)
                         }

--Declarations
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

--hooks
myManageHook :: ManageHook
myManageHook = (composeAll . concat $
            [[ className =? "Firefox"    --> doShift "web"
            , className =? "Dwb" --> doShift "web"
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
                onWorkspace "9" fsLayout $
                standardLayouts
    where
    standardLayouts = tiled ||| Mirror tiled ||| full

    rt = ResizableTall 1 (2/100) (1/2) []
    tiled = named "[]=" $ smartBorders rt    
    mtiled = named "M[]=" $ smartBorders $ Mirror rt
    rmtiled = named "RM[]=" $ noBorders $ reflectVert mtiled
    full = named "[]" $ noBorders Full
    
    fsLayout = full ||| tiled
    imLayout = rmtiled ||| full
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
--Search the web: mod + (s OR S-s) + search engine
searchEngineMap method = M.fromList $
    [ ((0, xK_d), method S.dictionary)
    , ((0, xK_t), method S.thesaurus)
    , ((0, xK_w), method $ S.searchEngine "wordReference" "http://www.wordreference.com/es/translation.asp?tranword=")
    , ((0, xK_b), method $ S.searchEngine "BBS" "http://bbs.archlinux.org/search.php?action=search&sort_dir=DESC&keywords=")
    , ((0, xK_a), method $ S.searchEngine "archwiki" "http://wiki.archlinux.org/index.php/Special:Search?search=")
    , ((0, xK_q), method $ S.searchEngine "duckduckgo" "https://duckduckgo.com/?q=")
    ]

myKeys conf = mkKeymap conf $ [
    --Making use of multimedia keys
      ("<XF86AudioMute>", safeSpawn "amixer" ["-q","set","Master","toggle"])
    , ("<XF86AudioLowerVolume>", safeSpawn "amixer" ["-q","set","Master","15%-"])
    , ("<XF86AudioRaiseVolume>", safeSpawn "amixer" ["-q","set","Master","15%+"])
    , ("<XF86AudioPlay>", safeSpawn "ncmpcpp" ["toggle"])
    , ("<XF86AudioStop>", safeSpawn "ncmpcpp" ["stop"])
    , ("<XF86AudioNext>", safeSpawn "ncmpcpp" ["next"])
    , ("<XF86AudioPrev>", safeSpawn "ncmpcpp" ["prev"])
    --Making right windows key useful.
    --Editing of ~/.xmodmap required
    , ("M5-<Return>", changeDir myXPConfig) --Change the dir of the topic (1)
    , ("M5-b c", safeSpawn "chromium" ["--incognito"])
    , ("M5-b d", safeSpawn "dwb" [])
    , ("M5-f", safeSpawn "pcmanfm" [])
    , ("M5-v", safeSpawn "VirtualBox" [])
    , ("M5-w", safeSpawn "v4l2-ctl" ["-c", "exposure_auto=1", "-c", "exposure_absolute=22"])
    , ("M5-t", safeSpawn "osmo" [] >> safeSpawn "hamster-time-tracker" [])
    , ("M5-d", safeSpawn "dropboxd" [])
    , ("M5-l", safeSpawn "xlock" ["-mode","blank","-geometry","1x1"])
    , ("M5-x", safeSpawn "bash" ["/home/user01/dev/clipsync/dmenu.sh"])
    , ("M5-S-x", safeSpawn "python" ["/home/user01/dev/clipsync/sync.py"])
    , ("M5-z", appendFilePrompt myXPConfig "/home/user01/Archives/txt/NOTES")

    --launching
    , ("M-<Return>", spawnShell) --Launch shell in topic (1)
    , ("M-f", safeSpawn "firefox" [])
    --search the web
    , ("M-s", SM.submap $ searchEngineMap $ S.promptSearch myXPConfig)
    , ("M-S-s", SM.submap $ searchEngineMap $ S.selectSearch)
    --actions
    , ("M-q", toggleWS' ["NSP"]) --Toggle between workspaces (5)
    , ("M-w", nextMatch History (className =? "URxvt")) -- Toggle between windows (6)
    , ("M-p", shellPrompt myXPConfig)
    , ("M-a f", focusUrgent) --Go to urgent window
    , ("M-a g", goToSelected defaultGSConfig { gs_cellwidth = 250 })
    , ("M-a k", killAllOtherCopies) --Kill all copied windows (2)
    , ("M-a s", scratchpadSpawnAction defaultConfig  {terminal = myTerminal})
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
    , ("M-,", sendMessage (IncMasterN 1)) --Inc win # in master area
    , ("M-.", sendMessage (IncMasterN (-1))) --Dec win # in master area
    --quit, or restart
    , ("M-S-e", io (exitWith ExitSuccess)) --Exit X
    , ("M-S-r", restart "xmonad" True) --Restart WM
    , ("M-S-o", safeSpawn "systemctl" ["poweroff"]) --Turn off computer
    ]
    -- mod-[1..9],          Switch to workspace N
    -- mod-shift-[1..9],    Move client to workspace N
    -- mod5-shift-[1..9],   Copy windows to workspace N (1)
    ++ [(m ++ k, windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) $ map show [1..9]
        , (f, m) <- [(W.greedyView, "M-"), (W.shift, "M-S-"), (copy, "M5-S-")]
    ]
    -- mod5-[1..9],         Switch to window N (3)
    ++ [(("M5-" ++ show k), focusNth i)
        | (i, k) <- zip [0 .. 8] [1..9]
    ]
