-- Setting any value here to nil will result in Blizzard defaults, if you want those instead.
RCConfig = {
  castbarOffset = 160,

  damageFont = true, -- Change damage font to something cooler

  portraitStyle = "3D", -- 3D, 2D, or class (for class icons)
  objectivesTextOutline = false,
  minimapZoneText = true, -- True = show zone text, False = hide
}

-- Fix some bag jank
SetInsertItemsLeftToRight(false)
