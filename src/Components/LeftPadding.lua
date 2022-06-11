local packages = script.Parent.Parent.Packages
local Roact = require(packages.Roact)

local LeftPadding = Roact.Component:extend("LeftPadding")

function LeftPadding:render()
	return Roact.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, 8);
	})
end

return LeftPadding