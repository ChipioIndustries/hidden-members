local packages = script.Parent.Parent.Packages
local Roact = require(packages.Roact)

local components = script.Parent
local Contents = require(components.Contents)
local Theme = require(components.Theme)

local App = Roact.Component:extend("App")

function App:init()
	self.rows, self.updateRows = Roact.createBinding(0)
end

function App:render()
	return Roact.createElement(Theme.Consumer, {
		render = function(theme)
			return Roact.createElement("ScrollingFrame", {
				CanvasSize = self.rows:map(function(rows)
					return UDim2.new(0, 0, 0, theme.rowHeight * rows)
				end);
				BackgroundColor3 = theme.backgroundColor;
				BorderSizePixel = 0;
				Size = UDim2.new(1, 0, 1, 0);
				VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
			}, {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.Name;
				});
				Contents = Roact.createElement(Contents, {
					setRows = self.updateRows;
				});
			})
		end
	})
end

return App