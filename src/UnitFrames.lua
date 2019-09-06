--------------------------------------
---      Class colored frames      ---
--------------------------------------
local function ClassColor(statusbar, unit)
	local _, class, c
	if UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and UnitClass(unit) then
		_, class = UnitClass(unit)
		c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
		statusbar:SetStatusBarColor(c.r, c.g, c.b)
	end
	if not UnitIsPlayer("target") then
		color = FACTION_BAR_COLORS[UnitReaction("target", "player")]
		if (not UnitPlayerControlled("target") and UnitIsTapDenied("target")) then
			TargetFrameHealthBar:SetStatusBarColor(0.5, 0.5, 0.5)
		else
			if color then
				TargetFrameHealthBar:SetStatusBarColor(color.r, color.g, color.b)
				TargetFrameHealthBar.lockColor = true
			end
		end
	end
	if not UnitIsPlayer("targettarget") then
		color = FACTION_BAR_COLORS[UnitReaction("targettarget", "player")]
		if (not UnitPlayerControlled("targettarget") and UnitIsTapDenied("targettarget")) then
			TargetFrameToTHealthBar:SetStatusBarColor(0.5, 0.5, 0.5)
		else
			if color then
				TargetFrameToTHealthBar:SetStatusBarColor(color.r, color.g, color.b)
				TargetFrameToTHealthBar.lockColor = true
			end
		end
	end
end

hooksecurefunc(
	"UnitFrameHealthBar_Update",
	function(self)
		ClassColor(self, self.unit)
	end
)

hooksecurefunc(
	"HealthBar_OnValueChanged",
	function(self)
		ClassColor(self, self.unit)
	end
)

--PLAYER
function StylePlayerFrame(self)
	PlayerName:SetPoint("BOTTOM", PlayerFrameHealthBar, "TOP", 0, 3)
	setFontOutline(PlayerName)

	PlayerFrameGroupIndicatorText:ClearAllPoints()
	PlayerFrameGroupIndicatorText:SetPoint("BOTTOMLEFT", PlayerFrame, "TOP", 0, -20)
	PlayerFrameGroupIndicatorLeft:Hide()
	PlayerFrameGroupIndicatorMiddle:Hide()
	PlayerFrameGroupIndicatorRight:Hide()

	PlayerFrameHealthBar:SetPoint("TOPLEFT", 106, -24)
	PlayerFrameHealthBar:SetHeight(26)
	PlayerFrameHealthBar.LeftText:ClearAllPoints()
	PlayerFrameHealthBar.LeftText:SetPoint("LEFT", PlayerFrameHealthBar, "LEFT", 10, 0)
	PlayerFrameHealthBar.RightText:ClearAllPoints()
	PlayerFrameHealthBar.RightText:SetPoint("RIGHT", PlayerFrameHealthBar, "RIGHT", -5, 0)
	PlayerFrameHealthBarText:SetPoint("CENTER", PlayerFrameHealthBar, "CENTER", 0, 0)

	PlayerFrameManaBar:SetPoint("TOPLEFT", 106, -52)
	PlayerFrameManaBar:SetHeight(13)
	PlayerFrameManaBar.LeftText:ClearAllPoints()
	PlayerFrameManaBar.LeftText:SetPoint("LEFT", PlayerFrameManaBar, "LEFT", 10, 0)
	PlayerFrameManaBar.RightText:ClearAllPoints()
	PlayerFrameManaBar.RightText:SetPoint("RIGHT", PlayerFrameManaBar, "RIGHT", -5, 1)
	PlayerFrameManaBarText:SetPoint("CENTER", PlayerFrameManaBar, "CENTER", 0, 0)
end
hooksecurefunc("PlayerFrame_ToPlayerArt", StylePlayerFrame)

--TARGET
function StyleTargetFrame(self, forceNormalTexture)
	local classification = UnitClassification(self.unit)
	self.deadText:ClearAllPoints()
	self.deadText:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0)
	self.levelText:SetPoint("RIGHT", self.healthbar, "BOTTOMRIGHT", 63, 10)
	self.nameBackground:Hide()
	self.Background:SetSize(119, 42)
	self.manabar.pauseUpdates = false
	self.manabar:Show()
	TextStatusBar_UpdateTextString(self.manabar)

	self.name:SetPoint("LEFT", self, 15, 36)
	setFontOutline(self.name)

	self.healthbar:SetSize(120, 26)
	self.healthbar:ClearAllPoints()
	self.healthbar:SetPoint("TOPLEFT", 5, -24)
	self.manabar:ClearAllPoints()
	self.manabar:SetPoint("TOPLEFT", 5, -52)
	self.manabar:SetSize(120, 13)

	--TargetOfTarget
	TargetFrameToTHealthBar:ClearAllPoints()
	TargetFrameToTHealthBar:SetPoint("TOPLEFT", 44, -15)
	TargetFrameToTHealthBar:SetHeight(8)
	TargetFrameToTManaBar:ClearAllPoints()
	TargetFrameToTManaBar:SetPoint("TOPLEFT", 44, -24)
	TargetFrameToTManaBar:SetHeight(5)

	if (forceNormalTexture) then
		self.haveElite = nil
		if (classification == "minus") then
			self.Background:SetSize(119, 42)
			self.Background:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 7, 35)
			--
			self.nameBackground:Hide()
			self.name:SetPoint("LEFT", self, 15, 36)
			self.healthbar:ClearAllPoints()
			self.healthbar:SetPoint("LEFT", 5, 13)
		else
			self.Background:SetSize(119, 42)
			self.Background:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 7, 35)
		end
	else
		self.haveElite = true
		TargetFrameBackground:SetSize(119, 42)
		self.Background:SetSize(119, 42)
		self.Background:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 7, 35)
	end

	if (self.questIcon) then
		self.questIcon:Hide()
	end
end
hooksecurefunc("TargetFrame_CheckClassification", StyleTargetFrame)

------------------------
-- PetFrame placement --
------------------------
-- Happiness Backdrop
local backdrop = {
  bgFile = "Interface\\BUTTONS\\WHITE8X8",
  edgeFile = nil,
  tile = false,
  tileSize = 32,
  edgeSize = 1,
  insets = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
  }
}
local CP=CreateFrame("Frame")
CP:RegisterEvent("PLAYER_LOGIN")
CP:RegisterEvent("UNIT_HAPPINESS")
CP:SetScript("OnEvent", function(self, event)
  PetFrameHappiness:SetBackdrop(backdrop)
  PetFrameHappiness:SetBackdropColor(0,0,0,1)
end)

-- Positioning
PetFrame:ClearAllPoints()
PetFrame:SetPoint("TOPLEFT", PlayerFrame, "BOTTOM", -40, 20)

PetFrameManaBar:ClearAllPoints()
PetFrameManaBar:SetPoint("TOPLEFT", PetPortrait, "TOPRIGHT", 2, -24)

PetFrameHappiness:ClearAllPoints()
PetFrameHappiness:SetPoint("TOPLEFT", PetFrameHealthBar, "TOPRIGHT", 2, -1)

PetFrameHealthBar:ClearAllPoints()
PetFrameHealthBar:SetPoint("BOTTOM", PetFrameManaBar, "TOP", 0, 0)
PetFrameHealthBar:SetHeight(18)

PetName:SetTextColor(1,1,1)
setFontOutline(PetName)
PetName:ClearAllPoints()
PetName:SetPoint("BOTTOM", PetFrameHealthBar, "TOP", 0, 5)

PetFrameHealthBar:SetWidth(80)
PetFrameHealthBar.LeftText:SetPoint("LEFT", PetFrameHealthBar, "LEFT", 0, 0)
PetFrameManaBar:SetWidth(80)
PetFrameHealthBar.RightText:SetPoint("RIGHT", PetFrameHealthBar, "RIGHT", 0, 0)
PetFrameHealthBarText:SetPoint("CENTER", PetFrameHealthBar, "CENTER", 0, 0)

-----------------------------------------------------------------
-- Changes default nametext color from yellow to white (r,g,b) --
-----------------------------------------------------------------
PlayerName:SetTextColor(1,1,1)
TargetFrameTextureFrameName:SetTextColor(1,1,1)
TargetFrameToTTextureFrameName:SetTextColor(1,1,1)

-----------------------
-- Loot Spec Display --
-----------------------
if RCConfig.lootSpecDisplay then
	local lootSpecId = nil
	local lootSpecName = ""
	local lootIcon = nil
	local defaultSpecName
	local defaultIcon

	local PlayerLootSpecFrame = CreateFrame("Frame", nil, PlayerFrame)
	PlayerLootSpecFrame:SetPoint("TOPLEFT", PlayerFrame, "BOTTOMRIGHT", -120, 32)
	PlayerLootSpecFrame:SetHeight(16)
	PlayerLootSpecFrame:SetWidth(16)
	PlayerLootSpecFrame.specname = PlayerLootSpecFrame:CreateFontString(nil)
	setDefaultFont(PlayerLootSpecFrame.specname, 11)
	PlayerLootSpecFrame.specname:SetPoint("LEFT", PlayerLootSpecFrame, "LEFT", 0, 0)
end

-- Hide
hooksecurefunc(
	"PlayerFrame_UpdateStatus",
	function()
		PlayerStatusTexture:Hide()
		PlayerRestGlow:Hide()
		PlayerStatusGlow:Hide()
	end
)
