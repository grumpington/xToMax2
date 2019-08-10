--Config Area

local xToMax2Height = 20
local xToMax2Width = 500
local xToMax2Anchor = {"CENTER", UIPARENT, "CENTER", 0, -275}
local xToMax2Point = {"CENTER", "xToMax2BarFrame","CENTER", 0, 0}
local xToMax2Texture = "Interface\\TargetingFrame\\UI-StatusBar"
local xToMax2Font = [[Fonts\FRIZQT__.TTF]]
local xToMax2FontSize = 12
local xToMax2FontFlags = "NONE"
local xToMax2Color = { r = 0, g = 1, b = 0 }
local xToMax2SliderHeightName = "Height"
local xToMax2SliderHeightTemplate = "OptionsSliderTemplate"

function comma_value(n)
  return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,"):gsub(",(%-?)$","%1"):reverse()
end
--[[
--here be the interface options panel
xToMax2Panel = CreateFrame("Frame", "xToMax2Panel", UIParent);
xToMax2Panel.name = "xToMax2";

--Making the sliders
xToMax2HeightSlider = CreateFrame("Slider", xToMax2HeightSlider, xToMax2Panel, xToMax2SliderHeightTemplate)
xToMax2HeightSlider:SetPoint("CENTER",0,0)
xToMax2HeightSlider.textLow = _G[xToMax2SliderHeightName.."Low"]
xToMax2HeightSlider.textHigh = _G[xToMax2SliderHeightName.."High"]
xToMax2HeightSlider.text = _G[xToMax2SliderHeightName.."Text"]
xToMax2HeightSlider:SetMinMaxValues(1,100)
xToMax2HeightSlider.minValue, xToMax2HeightSlider.maxValue = xToMax2HeightSlider:GetMinMaxValues()
--xToMax2HeightSlider.textLow:SetText(xToMaxHeightSlider.minValue)
--xToMax2HeightSlider.textHigh:SetText(100)
--xToMax2HeightSlider.text:SetText(xToMax2SliderHeightName)
xToMax2HeightSlider:SetValue(50)
xToMax2HeightSlider:SetValueStep(1)
xToMax2HeightSlider:SetScript("OnValueChanged", function(self,event,arg1) xToMax2ResizeHeight(event) end)

InterfaceOptions_AddCategory(xToMax2Panel);

-- Functions to resize the bar
function xToMax2ResizeHeight(value)
	xToMax2Height = value
end

function xToMax2ResizeWidth(value)
	xToMax2Width = value
end
--]]


--Creating the Frame
local xToMax2BarFrame = CreateFrame("Frame", "xToMax2BarFrame", UIParent)
xToMax2BarFrame:SetFrameStrata("HIGH")
xToMax2BarFrame:SetHeight(xToMax2Height)
xToMax2BarFrame:SetWidth(xToMax2Width)
xToMax2BarFrame:SetPoint(unpack(xToMax2Anchor))
xToMax2BarFrame:EnableMouse(true)
xToMax2BarFrame:SetMovable(true)
xToMax2BarFrame:SetResizable(true)
xToMax2BarFrame:SetClampedToScreen(true)

--Creating background and border
local backdrop = xToMax2BarFrame:CreateTexture(nil, "BACKGROUND")
backdrop:SetHeight(xToMax2Height)
backdrop:SetWidth(xToMax2Width)
backdrop:SetPoint(unpack(xToMax2Point))
backdrop:SetTexture(xToMax2Texture)
backdrop:SetVertexColor(0.1, 0.1, 0.1)
xToMax2BarFrame.backdrop = backdrop

--Creating the XP Bar
local xToMax2Bar = CreateFrame("StatusBar", "xToMax2Bar", xToMax2BarFrame)
xToMax2Bar:SetWidth(xToMax2Width)
xToMax2Bar:SetHeight(xToMax2Height)
xToMax2Bar:SetPoint(unpack(xToMax2Point))
xToMax2Bar:SetStatusBarTexture(xToMax2Texture)
xToMax2Bar:GetStatusBarTexture():SetHorizTile(false)
xToMax2Bar:SetStatusBarColor(xToMax2Color.r, xToMax2Color.g, xToMax2Color.b, 1)
xToMax2BarFrame.XtoMax2Bar = xToMax2Bar

--Creating the text on the bar
local Text = xToMax2Bar:CreateFontString("xToMax2BarText", "OVERLAY")
Text:SetFont(xToMax2Font, xToMax2FontSize, xToMax2FontFlags)
Text:SetPoint("CENTER", xToMax2Bar, "CENTER",0,1)
Text:SetAlpha(1)

--Making the bar movable and sizable
xToMax2BarFrame:SetScript("OnMouseDown", function(self, button)
	if not IsShiftKeyDown() then return end
	
	if button == "LeftButton" then
		self:StartMoving()
		self.isMoving = true
	--elseif button == "RightButton" then
		--self:StartSizing("BOTTOMRIGHT")
		--self.isSizing = true
	end
	
--[[
  if button == "LeftButton" and (IsShiftKeyDown()) and not self.isMoving then
   self:StartMoving();
   self.isMoving = true;
   --print("moving!");
  end
  
 --]]
end)

xToMax2BarFrame:SetScript("OnMouseUp", function(self, button)
  if not IsShiftKeyDown() then return end
  if button == "LeftButton" and self.isMoving then
   self:StopMovingOrSizing();
   self.isMoving = false;
   --print("Stopped moving");
  elseif button == "RightButton" and self.isSizing then
	self:StopMovingOrSizing();
	self.isSizing = false
  end
end)

--Making the magic Happen
local function UpdateStatus()
	local xToMax2XPLevel = {0, 400, 1300, 2700, 4800, 7600, 11200, 15700, 21100, 27600, 35200, 44000, 54100, 65500, 78400, 92800, 108800, 126500, 145900, 167200, 190400, 215600, 242900, 272300, 304000, 338000, 374400, 413300, 454700, 499000, 546400, 597200, 651700, 710300, 773100, 840200, 911800, 987900, 1068700, 1154400, 1245100, 1340900, 1441900, 1548200, 1660000, 1777500, 1900700, 2029800, 2164900, 2306100, 2453600, 2607500, 2767900, 2935000, 3108900, 3289700, 3477600, 3672600, 3874900};
	local xToMax2CurrentXP = UnitXP("player") + xToMax2XPLevel[UnitLevel("player")]
	local xToMax2MaxXP = 4084700
	local xToMax2PercXP = floor(xToMax2CurrentXP/xToMax2MaxXP*100)
	
	if UnitLevel("player") == 60 then
		backdrop:Hide()
		xToMax2Bar:Hide()
		xToMax2BarFrame:Hide()
	else
		xToMax2Bar:SetMinMaxValues(min(0, xToMax2CurrentXP), xToMax2MaxXP)
		xToMax2Bar:SetValue(xToMax2CurrentXP)
		Text:SetText(format("%s/%s (%s%%|cffb3e1ff|r)", comma_value(xToMax2CurrentXP), comma_value(xToMax2MaxXP), xToMax2PercXP))
	end
end

--Register Events
xToMax2BarFrame:RegisterEvent("PLAYER_LEVEL_UP")
xToMax2BarFrame:RegisterEvent("PLAYER_XP_UPDATE")
xToMax2BarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
xToMax2BarFrame:SetScript("OnEvent", UpdateStatus)