local M = {}

local data_path = vim.fn.stdpath("data")
local cache_config = string.format("%s/multishot.json", data_path)

function M.save(table)
    local file = io.open(cache_config, 'w')
    if file then
        file:write(vim.json.encode(table))
        file:close()
    else
        error('Multishot: Could not open file')
    end
end


function M.load()
    local file = io.open(cache_config, 'r')
    if file then
        local contents = file:read('*a')
        file:close()
        return vim.json.decode(contents)
    else
        return nil
    end
end


return M
