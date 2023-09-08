local M = {}


function M.save(table)
    local file = io.open('multishot.json', 'w')
    if file then
        file:write(vim.json.encode(table))
        file:close()
    else
        error('Multishot: Could not open file')
    end
end


function M.load()
    local file = io.open('multishot.json', 'r')
    if file then
        local contents = file:read('*a')
        file:close()
        return vim.json.decode(contents)
    else
        return nil
    end
end


return M
