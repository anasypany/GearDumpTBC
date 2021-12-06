-- 
charProf = ""


function AddLine(line)
	  -- print(line)
	charProf = charProf .. line .. "\n";
end

function ScanChar()

  charProf = ""


  -- setting basic player info
  playerName = GetUnitName("player")
  playerClass = UnitClass("player")
  playerLevel = UnitLevel("player")
  playerRace = UnitRace("player")
  playerSexId = UnitSex("player")

  if (playerSexId == 2) then
    playerSex = "Male"
  elseif (playerSexId == 3) then
    playerSex = "Female"
  end
  -- add player info to output
  AddLine("### START CHARACTER INFO")
  AddLine("name: " .. playerName)
  AddLine("class: " .. playerClass)
  AddLine("level: " .. playerLevel)
  AddLine("race: " .. playerRace)
  AddLine("sex: " .. playerSex)
  AddLine("### END CHARACTER INFO")
  
  AddLine("")
  AddLine("### START EQUIPPED GEAR")
  -- looping thru equipped gear

  for inventorySlot=1, 19, 1  do

    local equipId = GetInventoryItemID("player", inventorySlot)

    if (equipId) then

      local itemLink = GetInventoryItemLink('player', inventorySlot)
      local itemString = StringSplit(itemLink, "|")[3]
      local itemName = string.sub(string.sub((StringSplit(itemLink, "|")[4]), "2"), 2, -2)
      local itemStringSplit = StringSplit(itemString, ":")
      local itemId = itemStringSplit[2]
      local enchantId = itemStringSplit[3]
      local gem1Id = itemStringSplit[4]
      local gem2Id = itemStringSplit[5]
      local gem3Id = itemStringSplit[6]
      local gem4Id = itemStringSplit[7]
      local suffixId = itemStringSplit[8]


      AddLine("##itemName:".. itemName .. ",itemId:" .. itemId .. ",enchantId:" .. enchantId .. ",gem1Id:" .. gem1Id .. ",gem2Id:" .. gem2Id .. ",gem3Id:" .. gem3Id .. ",gem4Id:" .. gem4Id .. ",suffixId:" .. suffixId .. ",itemCount:1")
      -- AddLine("#itemId: " .. itemId)
      -- AddLine("##itemName: " .. itemName)
      -- AddLine("##enchantId: " .. enchantId)
      -- AddLine("##gem1Id: " .. gem1Id)
      -- AddLine("##gem2Id: " .. gem2Id)
      -- AddLine("##gem3Id: " .. gem3Id)
      -- AddLine("##gem4Id: " .. gem4Id)
      -- AddLine("##suffixId: " .. suffixId)

    end

  end

  AddLine("### END EQUIPPED GEAR")
  AddLine(" ")
  AddLine("### START INVENTORY GEAR")
  -- looping thru items in bags

  for bag=0, NUM_BAG_SLOTS do

    for bagSlots=1, GetContainerNumSlots(bag) do

      local itemId = GetContainerItemID(bag, bagSlots)

      if (itemId) then

        local itemLink = GetContainerItemLink(bag, bagSlots)
        local itemString = StringSplit(itemLink, "|")[3]
        local itemName = string.sub(string.sub((StringSplit(itemLink, "|")[4]), "2"), 2, -2)
        local itemStringSplit = StringSplit(itemString, ":")
        local enchantId = itemStringSplit[3]
        local gem1Id = itemStringSplit[4]
        local gem2Id = itemStringSplit[5]
        local gem3Id = itemStringSplit[6]
        local gem4Id = itemStringSplit[7]
        local suffixId = itemStringSplit[8]
        local _, itemCount = GetContainerItemInfo(bag, bagSlots)

        -- add inventory item info to frame text
        AddLine("##itemName:".. itemName .. ",itemId:" .. itemId .. ",enchantId:" .. enchantId .. ",gem1Id:" .. gem1Id .. ",gem2Id:" .. gem2Id .. ",gem3Id:" .. gem3Id .. ",gem4Id:" .. gem4Id .. ",suffixId:" .. suffixId .. ",itemCount:" .. itemCount)
        -- AddLine("#itemId: " .. itemId)
        -- AddLine("##itemName: " .. itemName)
        -- AddLine("##enchantId: " .. enchantId)
        -- AddLine("##gem1Id: " .. gem1Id)
        -- AddLine("##gem2Id: " .. gem2Id)
        -- AddLine("##gem3Id: " .. gem3Id)
        -- AddLine("##gem4Id: " .. gem4Id)
        -- AddLine("##suffixId: " .. suffixId)
        -- AddLine("##itemCount: " .. itemCount)

      end

    end

  end

  AddLine("### END INVENTORY GEAR")

  local gearFrame = getGearFame(charProf)
  gearFrame:Show()

end


function getGearFame(text)
  -- Frame code largely adapted from https://www.wowinterface.com/forums/showpost.php?p=323901&postcount=2
  if not gearDumpFrame then
    -- Main Frame
    frameConfig = {
      point = "CENTER",
      relativeFrame = nil,
      relativePoint = "CENTER",
      ofsx = 0,
      ofsy = 0,
      width = 750,
      height = 400,
    }
    local f = CreateFrame("Frame", "GearDumpFrame", UIParent, "DialogBoxFrame")
    f:ClearAllPoints()
    -- load position from local DB
    f:SetPoint(
      frameConfig.point,
      frameConfig.relativeFrame,
      frameConfig.relativePoint,
      frameConfig.ofsx,
      frameConfig.ofsy
    )
    f:SetSize(frameConfig.width, frameConfig.height)
    f:SetBackdrop({
      bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
      edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
      edgeSize = 16,
      insets = { left = 8, right = 8, top = 8, bottom = 8 },
    })
    f:SetMovable(true)
    f:SetClampedToScreen(true)
    f:SetScript("OnMouseDown", function(self, button)
      if button == "LeftButton" then
        self:StartMoving()
      end
    end)
    f:SetScript("OnMouseUp", function(self, button)
      self:StopMovingOrSizing()
      -- save position between sessions
      point, relativeFrame, relativeTo, ofsx, ofsy = self:GetPoint()
      frameConfig.point = point
      frameConfig.relativeFrame = relativeFrame
      frameConfig.relativePoint = relativeTo
      frameConfig.ofsx = ofsx
      frameConfig.ofsy = ofsy
    end)

    -- scroll frame
    local sf = CreateFrame("ScrollFrame", "GearDumpScrollFrame", f, "UIPanelScrollFrameTemplate")
    sf:SetPoint("LEFT", 16, 0)
    sf:SetPoint("RIGHT", -32, 0)
    sf:SetPoint("TOP", 0, -32)
    sf:SetPoint("BOTTOM", GearDumpFrameButton, "TOP", 0, 0)

    -- edit box
    local eb = CreateFrame("EditBox", "GearDumpEditBox", GearDumpScrollFrame)
    eb:SetSize(sf:GetSize())
    eb:SetMultiLine(true)
    eb:SetAutoFocus(true)
    eb:SetFontObject("ChatFontNormal")
    eb:SetScript("OnEscapePressed", function() f:Hide() end)
    sf:SetScrollChild(eb)

    -- resizing
    f:SetResizable(true)
    f:SetMinResize(150, 100)
    local rb = CreateFrame("Button", "GearDumpResizeButton", f)
    rb:SetPoint("BOTTOMRIGHT", -6, 7)
    rb:SetSize(16, 16)

    rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

    rb:SetScript("OnMouseDown", function(self, button)
      if button == "LeftButton" then
        f:StartSizing("BOTTOMRIGHT")
        self:GetHighlightTexture():Hide() -- more noticeable
      end
    end)
    rb:SetScript("OnMouseUp", function(self, button)
      f:StopMovingOrSizing()
      self:GetHighlightTexture():Show()
      eb:SetWidth(sf:GetWidth())
      -- save size between sessions
      frameConfig.width = f:GetWidth()
      frameConfig.height = f:GetHeight()
    end)

    GearDumpFrame = f
  end
  GearDumpEditBox:SetText(text)
  GearDumpEditBox:HighlightText()
  return GearDumpFrame
end


function StringSplit(string, delimiter)
  
  result = {}
  
  for match in (string..delimiter):gmatch("(.-)"..delimiter) do

    table.insert(result, match)
  
  end

  return result

end


SLASH_GEARDUMP1 = "/geardumptbc"
SlashCmdList["GEARDUMP"] = ScanChar