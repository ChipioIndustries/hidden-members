local Roact = require(script.Packages.Roact)

local App = require(script.Components.App)

local toolbar = plugin:CreateToolbar("HM")
local button = toolbar:CreateButton("hidden-members", "View hidden members of the selected class", "rbxassetid://9306628436", "Toggle")

local pluginGuiInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,
	false,
	false,
	300, 200,
	100, 20
)

local widget = plugin:CreateDockWidgetPluginGui("hidden-members", pluginGuiInfo)
widget.Title = "Hidden Members"
widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local appHandle
local appMounted = false

local function update()
	button:SetActive(widget.Enabled)
	if widget.Enabled then
		if not appMounted then
			local app = Roact.createElement(App)
			appHandle = Roact.mount(app, widget)
			appMounted = true
		end
	elseif appMounted then
		Roact.unmount(appHandle)
		appMounted = false
	end
end

local function toggleApp()
	widget.Enabled = not widget.Enabled
	update()
end

widget:BindToClose(toggleApp)
button.Click:Connect(toggleApp)
update()