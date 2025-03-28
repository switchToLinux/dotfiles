local tabs = ya.sync(function() return #cx.tabs end)

local function entry()
	local confirm = ya.confirm {
		pos = { "center", w = 60, h = 10 },
		title = "Ready to quit?",
		content = " 确定要退出?",
	}
	if confirm then
		ya.manager_emit("quit", {})
	end
end

return { entry = entry }