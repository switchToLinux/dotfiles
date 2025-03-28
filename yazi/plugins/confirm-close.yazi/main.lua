local tabs = ya.sync(function() return #cx.tabs end)

local function entry()
	local confirm = ya.confirm {
		pos = { "center", w = 60, h = 10 },
		title = "Ready to close?",
		content = " 确定关闭当前Tab页面?",
	}
	if confirm then
		ya.manager_emit("close", {})
	end
end

return { entry = entry }