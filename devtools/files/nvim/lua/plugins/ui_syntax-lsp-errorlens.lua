local PluginSpec = {
    'folke/trouble.nvim',
    dependencies = {
        'folke/lsp-colors.nvim'
    },
    -- cmd = { 'TroubleToggle', 'TroubleRefresh', 'TodoTrouble' },
    config = function()
        require('trouble').setup({

        })
        vim.diagnostic.config({
            virtual_text = { }
        })
        vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
            { silent = true, noremap = true }
        )
        vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
            { silent = true, noremap = true }
        )
        vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
            { silent = true, noremap = true }
        )
        vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
            { silent = true, noremap = true }
        )
        vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
            { silent = true, noremap = true }
        )
        vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
            { silent = true, noremap = true }
        )
    end
}

return PluginSpec
