local persistance = require('multishot.persistance')

local M = {}

Files = Files or persistance.load() or {}


function M.add_file(list_idx)
    if not list_idx then
        error('Multishot: list_idx is required')
    end

    local full_path = vim.fn.expand('%')
    local working_dir = vim.fn.getcwd()
    local relative_path = string.gsub(full_path, working_dir .. '/', '')

    Files[list_idx] = Files[list_idx] or {}

    table.insert(Files[list_idx], {
        path = relative_path,
    })

    persistance.save(Files)
end


function M.open_file(list_idx, file_idx)
    if not list_idx then
        error('Multishot: list_idx is required')
    end

    if not file_idx then
        error('Multishot: file_idx is required')
    end

    local list = Files[list_idx]
    if not list then
        return
    end

    local file = list[file_idx]
    if not file then
        return
    end

    local bufnr = vim.fn.bufnr(file.path)
    if bufnr ~= -1 then
        vim.cmd('b ' .. bufnr)
    else
        vim.cmd('e ' .. file.path)
    end
end


return M
