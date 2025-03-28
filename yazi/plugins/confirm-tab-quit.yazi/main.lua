local tabs = ya.sync(function() return #cx.tabs end)

local function entry()
	local tabs_count = tabs()
	if tabs_count > 1 then
		local confirm = ya.confirm {
			pos = { "center", w = 60, h = 10 },
			title = "Ready to quit?",
			content = "提示:Tab页没关闭，确定要退出?",
		}
		if confirm then
			ya.manager_emit("quit", {})
		end
	else
		ya.manager_emit("quit", {})
	end
end

return { entry = entry }