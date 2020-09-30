{-# LANGUAGE MultiParamTypeClasses, FlexibleInstances #-}

import XMonad
import XMonad.Config.Desktop		-- Desktop environment integration.
import XMonad.Util.EZConfig		-- Keybinding Configuration.
import XMonad.Util.SpawnOnce		-- Spawn Program Once on Startup.
import XMonad.Layout.Spacing		-- Add gaps between windows.
import XMonad.Layout.WindowArranger	-- Resize Windows.
import XMonad.Layout.Grid		-- Grid Layout.
import XMonad.Layout.Spiral		-- Sprial Layout.
import XMonad.Layout.NoBorders		-- Remove Fullscreen Borders.
import XMonad.Hooks.EwmhDesktops	-- EWMH Window Hints.
import XMonad.Hooks.DynamicLog		-- XMobar Status Info.
import qualified XMonad.StackSet as W
import XMonad.Layout.Decoration
import XMonad.Util.Types

-- The Startup Hook.
myStartupHook = do
	spawnOnce "~/.fehbg &"
	spawnOnce "picom &"

-- The main function.
main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP { ppCurrent	= xmobarColor "#904b5b" "" . wrap "[" "]"
		, ppTitle	= xmobarColor "#b4a6b3" "" . wrap "" ""
		, ppHidden	= xmobarColor "#444c42" "" . wrap "[" "]"
		, ppLayout 	= const ""		
		}

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- Main configuration, override the defaults to your liking.
myConfig = def
	{ terminal		= myTerminal
	, modMask		= myModMask
	, borderWidth		= myBorderWidth
	, layoutHook		= myLayoutHook 
	, normalBorderColor 	= myNormalBorderColor
	, focusedBorderColor	= myFocusedBorderColor
	}	

-- Keybinding Configuration.
	`additionalKeys`
       [ ((mod1Mask .|. controlMask              , xK_s    ), sendMessage  Arrange         )
       , ((mod1Mask .|. controlMask .|. shiftMask, xK_s    ), sendMessage  DeArrange       )
       , ((mod1Mask .|. controlMask              , xK_Left ), sendMessage (MoveLeft      1))
       , ((mod1Mask .|. controlMask              , xK_Right), sendMessage (MoveRight     1))
       , ((mod1Mask .|. controlMask              , xK_Down ), sendMessage (MoveDown      1))
       , ((mod1Mask .|. controlMask              , xK_Up   ), sendMessage (MoveUp        1))
       , ((mod1Mask                 .|. shiftMask, xK_Left ), sendMessage (IncreaseLeft  1))
       , ((mod1Mask                 .|. shiftMask, xK_Right), sendMessage (IncreaseRight 1))
       , ((mod1Mask                 .|. shiftMask, xK_Down ), sendMessage (IncreaseDown  1))
       , ((mod1Mask                 .|. shiftMask, xK_Up   ), sendMessage (IncreaseUp    1))
       , ((mod1Mask .|. controlMask .|. shiftMask, xK_Left ), sendMessage (DecreaseLeft  1))
       , ((mod1Mask .|. controlMask .|. shiftMask, xK_Right), sendMessage (DecreaseRight 1))
       , ((mod1Mask .|. controlMask .|. shiftMask, xK_Down ), sendMessage (DecreaseDown  1))
       , ((mod1Mask .|. controlMask .|. shiftMask, xK_Up   ), sendMessage (DecreaseUp    1))
       ]

-- Configuration Options.
myTerminal		= "alacritty"
myModMask		= mod1Mask
myBorderWidth		= 1
myNormalBorderColor	= "#444c42"
myFocusedBorderColor	= "#904b5b"

-- Layout Options.
myLayoutHook		= myDecorate $ myGaps $ windowArrange $ smartBorders (mySpiral ||| Grid)
	where
	myGaps		= spacingRaw True (Border 100 100 100 100) True (Border 10 10 10 10) True
	mySpiral	= spiral (6/7)

-- Side Decorations.
data SideDecoration a = SideDecoration Direction2D
  deriving (Show, Read)

instance Eq a => DecorationStyle SideDecoration a where

  shrink b (Rectangle _ _ dw dh) (Rectangle x y w h)
    | SideDecoration U <- b = Rectangle x (y + fi dh) w (h - dh)
    | SideDecoration R <- b = Rectangle x y (w - dw) h
    | SideDecoration D <- b = Rectangle x y w (h - dh)
    | SideDecoration L <- b = Rectangle (x + fi dw) y (w - dw) h

  pureDecoration b dw dh _ st _ (win, Rectangle x y w h)
    | win `elem` W.integrate st && dw < w && dh < h = Just $ case b of
      SideDecoration U -> Rectangle x y w dh
      SideDecoration R -> Rectangle (x + fi (w - dw)) y dw h
      SideDecoration D -> Rectangle x (y + fi (h - dh)) w dh
      SideDecoration L -> Rectangle x y dw h
    | otherwise = Nothing

myTheme :: Theme
myTheme = defaultTheme
  { activeColor		= "#904b5b"
  , inactiveColor	= "#444c42"
  , activeBorderColor	= "#904b5b"
  , inactiveBorderColor	= "#444c42"
  , decoWidth		= 20
  }

myDecorate :: Eq a => l a -> ModifiedLayout (Decoration SideDecoration DefaultShrinker) l a
myDecorate = decoration shrinkText myTheme (SideDecoration L)
