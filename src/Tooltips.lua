local CF=CreateFrame("Frame")
CF:RegisterEvent("PLAYER_LOGIN")
CF:SetScript("OnEvent", function(self, event)
	-- Tooltips anchored on mouse
	hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self, parent)
		if (InCombatLockdown()) then
	    self:SetOwner(parent, "ANCHOR_NONE")
	    self:ClearAllPoints()
	    self:SetPoint(unpack({"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -200, 220}))
		else
			self:SetOwner(parent, "ANCHOR_CURSOR")
		end
	end)

	local bar = GameTooltipStatusBar
	bar.bg = bar:CreateTexture(nil, "BACKGROUND")
	bar.bg:SetAllPoints()
	bar.bg:SetColorTexture(1, 1, 1)
	bar.bg:SetVertexColor(0.2, 0.2, 0.2, 0.8)
	bar.TextString = bar:CreateFontString(nil, "OVERLAY")
	bar.TextString:SetPoint("CENTER")
	setDefaultFont(bar.TextString, 11)
	bar.capNumericDisplay = true
	bar.lockShow = 1

	-- Class colours
	GameTooltip:HookScript("OnTooltipSetUnit", function(tooltip)
		local _, unit = tooltip:GetUnit()

		if UnitIsPlayer(unit) then
			local _, class = UnitClass(unit)
			local r, g, b = GetClassColor(class)

			local text = GameTooltipTextLeft1:GetText()
			GameTooltipTextLeft1:SetFormattedText("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, text:match("|cff\x\x\x\x\x\x(.+)|r") or text)
		end
	end)

	GameTooltip:HookScript("OnUpdate", function(tooltip)
		GameTooltip:SetBackdropColor(0.13,0.13,0.13) -- Simpler and themed BG color
	end)
end)
