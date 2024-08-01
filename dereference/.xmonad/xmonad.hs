import XMonad
import XMonad.Config.Desktop (desktopConfig)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Hooks.ManageDocks (avoidStruts)
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.Tabbed (Theme (..), shrinkText, tabbed)
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.Run (spawnPipe)
import XMonad.Layout.Spacing(spacing)
import XMonad.Layout.ResizableTile(ResizableTall(..))
import XMonad.Layout.TwoPane(TwoPane(..))
import qualified Data.Map as M
import qualified XMonad.Layout.Dwindle as Dwindle
import qualified XMonad.Hooks.DynamicLog as DL
import XMonad.Hooks.DynamicLog (PP(..), wrap, shorten, xmobarColor)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog


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
        startupHook = myStartupHook
        -- keys = myKeys
      } `additionalKeys`
           [ ((modm, xK_slash), spawn "feh --zoom 180 ~/my/wallpapers/xmbindings.png")
           , ((0                     , 0x1008FF11), spawn "amixer -q sset Master 2%-")
           , ((0                     , 0x1008FF13), spawn "amixer -q sset Master 2%+")
           -- , ((0                     , 0x1008FF12), spawn "amixer set Master toggle")
           ]
  where
    modm = mod4Mask

myLayout =
  avoidStruts $
    noBorders (tabbed shrinkText myTabConfig)
    -- ||| tiled
    ||| twopane
    ||| Dwindle.Spiral Dwindle.L Dwindle.CW (3/2) (11/10) -- L means the non-main windows are put to the left.
  where
     -- The last parameter is fraction to multiply the slave window heights
     -- with. Useless here.
     tiled = spacing 3 $ ResizableTall nmaster delta ratio []
     -- In this layout the second pane will only show the focused window.
     twopane = spacing 0 $ TwoPane delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

-- myLayout =
--   avoidStruts $
--     noBorders $
--       tabbed shrinkText myTabConfig

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

{- myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $ M.toList (keys desktopConfig) <> []
    -- -- launch a terminal
    -- [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    -- -- close focused window
    -- , ((modm .|. shiftMask, xK_q     ), kill)
    --  -- Rotate through the available layout algorithms
    -- , ((modm,               xK_space ), sendMessage NextLayout)

    -- --  Reset the layouts on the current workspace to default
    -- , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    -- ] -}

myStartupHook :: X ()
myStartupHook = do
  -- spawnOnce "feh --bg-scale --no-fehbg /home/kolay/my/wallpapers/xmbindings.png"
  spawnOnce "feh --bg-center --no-fehbg ~/my/wallpapers/composition-a-xxi-1925.jpg"
  spawn "x-terminal-emulator -e ~/hacky.sh ~/.xmonad/vpn.sh"


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
