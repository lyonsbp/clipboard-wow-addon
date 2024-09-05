SLASH_RELOAD1 = '/rl'
local function ReloadHandler(msg, editBox)
  ReloadUI()
end
SlashCmdList["RELOAD"] = ReloadHandler

SLASH_CLIPBOARD1 = '/cb'
local function ClipboardHandler(msg, editBox)
  print(msg)
  CreateClipboardFrame()
end
SlashCmdList["CLIPBOARD"] = ClipboardHandler

-- ACE3 Setups
ClipboardAddon = LibStub("AceAddon-3.0"):NewAddon("Clipboard", "AceConsole-3.0", "AceEvent-3.0")
function ClipboardAddon:OnInitialize()
  --self:RegisterEvent("ZONE_CHANGED")
  print('Clipboard OnInit')
end

function ClipboardAddon:OnEnable()
  -- Called when the addon is enabled
  print('Clipboard OnEnable')
end

function ClipboardAddon:OnDisable()
  -- Called when the addon is disabled
  print('Clipboard OnDisable')
end

-- TODO: Attempt to hijack item hover or click while cb frame is open. 
function CreateClipboardFrame() 
  AceGUI = LibStub("AceGUI-3.0")
  -- Create a container frame
  local f = AceGUI:Create("Frame")
  f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
  f:SetTitle("Item Clipboard")
  f:SetStatusText("Status Bar")
  f:SetLayout("Flow")

  local editBox = AceGUI:Create("EditBox")
  editBox:SetLabel("Drag/Link Item Here")
  f:AddChild(editBox)
  editBox:SetCallback("OnTextChanged", function(text) AddItem(text) end )

  function AddItem(itemLink)
    print(itemLink)
    local group = AceGUI:Create("SimpleGroup")
    local editBox = AceGUI:Create("EditBox")
    editBox:SetText(itemLink)
    
    local countSlider = AceGUI:Create("Slider")
    countSlider:SetWidth(120)
    countSlider:SetLabel("Count")
    
    group:SetLayout("Flow")
    group:AddChild(editBox)
    group:AddChild(countSlider)

    f:AddChild(group)
  end

  function ReceiveItem(ref, type)
    if CursorHasItem() then
      item, itemId, itemLink = GetCursorInfo()
      ClearCursor()
      AddItem(itemLink)
    end
  end
  f.frame:SetScript("OnMouseUp", ReceiveItem)
end
