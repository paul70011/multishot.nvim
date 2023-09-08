require('multishot.init')

local M = {}


local function create_window(content)
    local ui = vim.api.nvim_list_uis()[1]

    local width = 60
    local height = 10

    local opts = {
        relative = "editor",
        width = width,
        height = height,
        row = ui.height / 2 - height / 2,
        col = ui.width / 2 - width / 2,
        anchor = "NW",
        style = "minimal",
        -- border = "single",
    }

    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

    vim.api.nvim_open_win(buf, true, opts)

    return buf
end


function M.on_buffer_close(bufnr, list_idx)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    Files[list_idx] = lines
    require('multishot.persistance').save(Files)
    vim.api.nvim_buf_delete(bufnr, { force = true })
end


function M.show_list(list_idx)
    local content = Files[list_idx] or {}

    local bufnr = create_window(content)

    vim.cmd(string.format([[
        augroup ScratchBufferAutocmd
            autocmd!
            autocmd BufLeave <buffer=%d> lua require'multishot.ui'.on_buffer_close(%d, %d)
        augroup END
    ]], bufnr, bufnr, list_idx))

    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<esc>', '<cmd>q<cr>', { noremap = true, silent = true })
end


return M
