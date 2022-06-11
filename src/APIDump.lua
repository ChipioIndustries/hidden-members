local HttpService = game:GetService("HttpService")

local Llama = require(script.Parent.Packages.Llama)

local VERSION_ENDPOINT = "https://s3.amazonaws.com/setup.roblox.com/versionQTStudio"
local DUMP_ENDPOINT = "https://s3.amazonaws.com/setup.roblox.com/%s-API-Dump.json"
local ROOT_SUPERCLASS = "<<<ROOT>>>"
local MEMBER_TYPE_PROPERTY = "Property"
local DEPRECATED_TAG = "Deprecated"
local HIDDEN_TAG = "Hidden"

local APIDump = {}

local success, result = pcall(function()
	local latestVersion = HttpService:GetAsync(VERSION_ENDPOINT)
	local apiDump = HttpService:GetAsync((DUMP_ENDPOINT):format(latestVersion))
	return HttpService:JSONDecode(apiDump)
end)

if success then
	APIDump.dump = result
else
	warn("[Hidden Members] Failed to get API dump:", result)
end

function APIDump:getClassMembers(className)
	if self.dump then
		for _, class in ipairs(self.dump.Classes) do
			if class.Name == className then
				local members = class.Members
				if class.Superclass ~= ROOT_SUPERCLASS then
					members = Llama.List.concat(members, self:getClassMembers(class.Superclass))
				end
				return members
			end
		end
	else
		return {}
	end
end

function APIDump:getHiddenClassProperties(className)
	if self.dump then
		local members = self:getClassMembers(className)
		local hiddenProperties = {}
		for _, member in ipairs(members) do
			if
				member.MemberType == MEMBER_TYPE_PROPERTY
				and (
					(member.Tags and (table.find(member.Tags, DEPRECATED_TAG) or table.find(member.Tags, HIDDEN_TAG)))
					or (member.ValueType and member.ValueType.Name == "CFrame")
				)
			then
				table.insert(hiddenProperties, member.Name)
			end
		end
		return hiddenProperties
	else
		return {}
	end
end

return APIDump