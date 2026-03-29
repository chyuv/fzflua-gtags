local M = {}

local fzflua = require("fzf-lua")

--- @param items table: { "file:line:content", ... }
local function fzflua_preview(title, prompt, items)
	fzflua.fzf_exec(items, {
		prompt = prompt .. " > ",

		hl_line = true,
		previewer = "builtin",

		fzf_opts = {
			["--delimiter"] = ":",
			["--nth"] = "1,2,3",
		},

		-- on select
		actions = {
			["default"] = function(selected)
				local file, line = selected[1]:match("^(.-):(%d+)$")
				if file and line then
					vim.cmd("edit " .. vim.fn.fnameescape(file))
					vim.cmd("normal! " .. line .. "zz")
				end
			end,
		},

		winopts = { title = " " .. title .. " " },
	})
end

local function gtags_init()
	local res = vim.system({ "global", "-pd" }, { text = true }):wait()

	if res.code ~= 0 then
		vim.schedule(function()
			vim.notify("fzflua-gtags: init failed\n" .. res.stderr, vim.log.levels.WARN)
		end)
	else
		vim.env.GTAGSROOT = vim.split(res.stdout, "\n", { trimempty = true })[1]
		M.gtagsroot = vim.env.GTAGSROOT
	end
end

local function gtags_update()
	if not M.gtagsroot then
		gtags_init()
	end

	vim.system({ "global", "-u" }, { text = true }, function(res)
		if res.code ~= 0 then
			vim.schedule(function()
				vim.notify("fzflua-gtags: update failed\n" .. res.stderr, vim.log.levels.WARN)
			end)
		else
			vim.schedule(function()
				vim.notify("fzflua-gtags: updated", vim.log.levels.INFO)
			end)
		end
	end)
end

local function gtags_find(typ, pattern)
	if not M.gtagsroot then
		gtags_init()
	end

	local args
	if typ == "defs" then
		args = "-x"
	elseif typ == "refs" then
		args = "-xr"
	else
		error("bad call: gtags_find")
	end

	if not pattern or pattern:match("^%s*$") then -- pattern is nil or "" or " "
		pattern = vim.fn.expand("<cword>") -- use word under cursor
	end

	vim.system({ "global", args, pattern }, { text = true }, function(res)
		if res.code ~= 0 then
			vim.schedule(function()
				vim.notify("fzflua-gtags: find " .. typ .. " failed\n" .. res.stderr, vim.log.levels.WARN)
			end)
			return
		end

		local rows = vim.split(res.stdout, "\n", { trimempty = true })
		local items = {}
		local patt = "^%S+%s+(%d+)%s+(%S+)(.*)$"
		local match = string.match
		for _, row in ipairs(rows) do
			local line, file, content = match(row, patt)
			items[#items + 1] = file .. ":" .. line .. ":" .. content
		end

		vim.schedule(function()
			fzflua_preview("Gtags " .. typ, pattern, items)
		end)
	end)
end

local function gtags_find_defs(pattern)
	gtags_find("defs", pattern)
end

local function gtags_find_refs(pattern)
	gtags_find("refs", pattern)
end

function M.setup()
	vim.schedule(function()
		vim.api.nvim_create_user_command("GtagsFindDefs", function(opts)
			gtags_find_defs(opts.args)
		end, {
			nargs = "?",
		})

		vim.api.nvim_create_user_command("GtagsFindRefs", function(opts)
			gtags_find_refs(opts.args)
		end, {
			nargs = "?",
		})

		vim.api.nvim_create_user_command("GtagsUpdate", gtags_update, {})
	end)
end

return M
