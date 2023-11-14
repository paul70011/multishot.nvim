require('multishot.init')

local M = {}


local function create_window(content)
    local ui = vim.api.nvim_list_uis()[1]

    local width = math.floor(ui.width)
    local height = 20

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
    local working_dir = vim.fn.getcwd()

    Files[working_dir] = Files[working_dir] or {}
    Files[working_dir][list_idx] = Files[working_dir][list_idx] or {}

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local merged_lines = {}

    for _, line in ipairs(lines) do
        if line ~= '' then
            table.insert(merged_lines, {
                path = line,
            })
        end
    end

    Files[working_dir][list_idx] = merged_lines
    require('multishot.persistance').save(Files)
    vim.api.nvim_buf_delete(bufnr, { force = true })
end


function M.show_list(list_idx)
    if not list_idx then
        error("list_idx is required")
    end

    local working_dir = vim.fn.getcwd()

    local project = Files[working_dir] or {}
    local list = project[list_idx] or {}

    local content = {}

    for _, file in ipairs(list) do
        if type(file) == 'table' then
            table.insert(content, file.path)
        end
    end

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
