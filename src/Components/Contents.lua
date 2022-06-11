local Selection = game:GetService("Selection")

local source = script.Parent.Parent
local APIDump = require(source.APIDump)

local packages = source.Packages
local Llama = require(packages.Llama)
local Roact = require(packages.Roact)

local components = script.Parent
local Label = require(components.Label)
local Theme = require(components.Theme)

local Contents = Roact.Component:extend("Contents")

function Contents:init()
	self.selectionChangedConnection = Selection.SelectionChanged:Connect(function()
		local selectedItem = Selection:Get()[1]
		if selectedItem ~= self.state.selectedItem then
			self:setState({
				selectedItem = selectedItem or Roact.None;
			})
		end
	end)

	self:setState({
		selectedItem = Selection:Get()[1]
	})
end

function Contents:render()
	local state = self.state
	local selectedItem = state.selectedItem

	local props = self.props
	local setRows = props.setRows

	return Roact.createElement(Theme.Consumer, {
		render = function(theme)
			local contents = {}

			if selectedItem then
				local members = APIDump:getHiddenClassProperties(selectedItem.ClassName)
				for _, memberName in ipairs(members) do
					local memberValue = "LOCKED"
					pcall(function()
						memberValue = selectedItem[memberName]
					end)
					contents[memberName] = Roact.createElement("Frame", {
						BackgroundTransparency = 1;
						Size = UDim2.new(1, 0, 0, theme.rowHeight);
					}, {
						Title = Roact.createElement(Label, {
							position = UDim2.new(0, 0, 0, 0);
							size = UDim2.new(0.45, 0, 1, 0);
							text = memberName;
						});
						Value = Roact.createElement(Label, {
							position = UDim2.new(0.45, 0, 0, 0);
							size = UDim2.new(0.55, 0, 1, 0);
							text = tostring(memberValue);
						});
					})
				end
			end

			setRows(Llama.Dictionary.count(contents))

			return Roact.createFragment(contents)
		end
	})
end

function Contents:willUnmount()
	if self.selectionChangedConnection then
		self.selectionChangedConnection:Disconnect()
	end
end

return Contents