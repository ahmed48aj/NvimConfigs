
require "core"

-- Load custom init if it exists
local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]
if custom_init_path then
  dofile(custom_init_path)
end

-- Load default mappings
require("core.utils").load_mappings()

-- Lazy.nvim bootstrap
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

-- Load defaults
dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"

-- Insert mode jj to escape
vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true, silent = true })

----------------------------------------------------------------
-- Transparent.nvim automatic setup inside init.lua
----------------------------------------------------------------
vim.schedule(function()
    if not pcall(require, "transparent") then
        return
    end

    -- Setup transparent.nvim
    local transparent = require("transparent")
    transparent.setup({
        groups = {},        -- clear default groups
        extra_groups = {},  -- handled manually
        exclude_groups = {},
    })

    -- Function to clear background highlights (main buffer + tree)
    local function clear_bg()
        local hl = {
            "Normal", "NormalNC", "SignColumn", "VertSplit",
            "StatusLine", "StatusLineNC", "LineNr", "NonText",
            "CursorLineNr", "EndOfBuffer",
            "NvimTreeNormal", "NvimTreeNormalNC", "NvimTreeEndOfBuffer",
            "NvimTreeVertSplit", "NvimTreeStatusLine",
        }
        for _, group in ipairs(hl) do
            vim.cmd("hi " .. group .. " guibg=NONE ctermbg=NONE")
        end
    end

    -- Apply transparency on startup
    vim.api.nvim_create_autocmd("VimEnter", { callback = clear_bg })

    -- Reapply transparency whenever colorscheme changes
    vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = clear_bg })

    -- Optional keybind to manually reapply transparency
    vim.keymap.set('n', '<leader>tt', clear_bg, { desc = "Reapply Transparency" })

    -- Apply transparency specifically after nvim-tree loads
    vim.api.nvim_create_autocmd("BufWinEnter", {
        pattern = "NvimTree_*",
        callback = function()
            clear_bg()
        end,
    })
end)

