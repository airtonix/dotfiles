local PluginSpec = {
    'sindrets/diffview.nvim',
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    config = function()
        local command = ":DiffviewOpen"

        vim.cmd([[ set fillchars+=diff:╱]])

        require('legendary').keymaps({
            {
                "<Leader>d",
                {
                    -- s = string.format("<C-O>%s<CR>", command),
                    -- v = string.format("<C-O>%s<CR>", command),
                    -- x = string.format("<C-O>%s<CR>", command),
                    n = string.format("%s<CR>", command)
                }
            }
        })
    end
}

return PluginSpec
