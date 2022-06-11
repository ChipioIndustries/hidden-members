local packages = script.Parent.Parent.Packages
local Roact = require(packages.Roact)

local components = script.Parent
local LeftPadding = require(script.Parent.LeftPadding)
local Theme = require(components.Theme)

local Label = Roact.Component:extend("Label")

function Label:render()
	local props = self.props
	local position = props.position
	local size = props.size
	local text = props.text

	return Roact.createElement(Theme.Consumer, {
		render = function(theme)
			return Roact.createElement("TextLabel", {
				BackgroundColor3 = theme.backgroundColor;
				BorderColor3 = theme.borderColor;
				Font = Enum.Font.SourceSans;
				Position = position;
				Size = size;
				Text = text;
				TextColor3 = theme.textColor;
				TextSize = 18;
				TextXAlignment = Enum.TextXAlignment.Left;
			}, {
				Padding = Roact.createElement(LeftPadding);
			})
		end
	})
end

return Label