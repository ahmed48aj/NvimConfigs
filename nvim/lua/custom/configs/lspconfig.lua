
local lspconfig = require("lspconfig")
local config = require("plugins.configs.lspconfig")  -- NvChad default LSP config

-- Pyright setup
lspconfig.pyright.setup({
    on_attach = config.on_attach,        -- use default on_attach
    capabilities = config.capabilities,  -- use default capabilities
})

-- Optional: print to confirm
print("Pyright LSP loaded")

