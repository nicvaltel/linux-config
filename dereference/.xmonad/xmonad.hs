import XMonad
import XMonad.Actions.SpawnOn(spawnOn, spawnAndDo, manageSpawn)
import XMonad.Config.Desktop (desktopConfig)
import XMonad.Hooks.ManageDocks (avoidStruts)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog (PP(..), wrap, shorten, xmobarColor)
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.Tabbed (Theme (..), shrinkText, tabbed)
import XMonad.Layout.Spacing(spacing, spacingRaw, Border(..))
import XMonad.Layout.ResizableTile(ResizableTall(..))
import XMonad.Layout.TwoPane(TwoPane(..))
import XMonad.ManageHook(doShift)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.SessionStart(doOnce)
import XMonad.Util.SpawnOnce (spawnOnce, spawnOnOnce)
import XMonad.Util.Run (spawnPipe)
import qualified Data.Map as M
import qualified XMonad.Layout.Dwindle as Dwindle
import qualified XMonad.Hooks.DynamicLog as DL


-- TODO : The ewmhFullscreen function does not exist in these versions. Instead of it, you can try to add fullscreenEventHook to your handleEventHook to achieve similar functionality (how to do this is explained in the documentation of XMonad.Hooks.EwmhDesktops
main = do
  xmproc <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobar.config"
  -- xmonad . ewmh . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey $
  xmonad $ 
    desktopConfig
      { terminal = "konsole",
        modMask = modm,
        borderWidth = 2,
        focusedBorderColor = "#009999",
        normalBorderColor = "#993333",
        layoutHook = myLayout,
        startupHook = myStartupHook,
        workspaces = myWorkspaces,
        manageHook = manageSpawn <+> manageHook def -- manageSpawn need for spawnOn/spawnOnOnce 
      } `additionalKeys` (myAdditionalKeys modm)
  where
    modm = mod4Mask

myAdditionalKeys modm =
  [ ((modm, xK_slash), spawn "feh --zoom 180 ~/my/wallpapers/xmbindings.png")
  , ((0                     , 0x1008FF11), spawn "amixer -q sset Master 2%-")
  , ((0                     , 0x1008FF13), spawn "amixer -q sset Master 2%+")
  -- , ((0                     , 0x1008FF12), spawn "amixer set Master toggle") -- TODO don't know how to turn it back after turn off
  ]

myLayout =
  avoidStruts $
    noBorders (tabbed shrinkText myTabConfig)
    -- ||| tiled
    ||| twopane
    ||| Dwindle.Spiral Dwindle.L Dwindle.CW (3/2) (11/10) -- L means the non-main windows are put to the left.
  where
     -- The last parameter is fraction to multiply the slave window heights with. Useless here.
     -- tiled = spacing 3 $ ResizableTall nmaster delta ratio []

     -- In this layout the second pane will only show the focused window.
     -- twopane = spacingRaw True defBorder False defBorder True $ TwoPane delta ratio
     twopane = TwoPane delta ratio

     defBorder = Border
      { top = 5 
      , bottom = 5
      , right = 5
      , left = 5
      }

     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

myTabConfig =
  def
    { activeColor = "#556064",
      inactiveColor = "#2F3D44",
      urgentColor = "#FDF6E3",
      activeBorderColor = "#454948",
      inactiveBorderColor = "#454948",
      urgentBorderColor = "#268BD2",
      activeTextColor = "#80FFF9",
      inactiveTextColor = "#1ABC9C",
      urgentTextColor = "#1ABC9C",
      fontName = "xft:Noto Sans CJK:size=10:antialias=true"
    }

myWorkspaces = ["ws1","ws2","ws3","ws4","ws5","ws6","ws7","ws8","ws9"]

myStartupHook :: X ()
myStartupHook = do
  -- spawnOnce "feh --bg-scale --no-fehbg /home/kolay/my/wallpapers/xmbindings.png"
  -- spawnOnce "feh --bg-center --no-fehbg ~/my/wallpapers/composition-a-xxi-1925.jpg"
  spawnOnce "feh --bg-max --no-fehbg ~/my/wallpapers/geysha.png"
  spawnOnOnce "ws9" "x-terminal-emulator -e ~/hacky.sh ~/.xmonad/vpn.sh"


myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = DL.xmobarStrip
    -- , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . DL.wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    -- , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = DL.xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""
