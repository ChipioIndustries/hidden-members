local packages = script.Parent.Parent.Packages
local Roact = require(packages.Roact)

local Theme = Roact.createContext({
	backgroundColor = Color3.fromRGB(46, 46, 46);
	borderColor = Color3.fromRGB(34, 34, 34);
	textColor = Color3.fromRGB(220, 220, 220);
	rowHeight = 24;
})

return Theme