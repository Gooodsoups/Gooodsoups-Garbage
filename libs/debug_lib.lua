local DebugLib = {}

local function is_script_block(v)
    return type(v) == "table" and v.eval == true and type(v.func) == "function"
end

local function keys_sorted(t)
    local ks = {}
    for k in pairs(t) do table.insert(ks, k) end
    table.sort(ks, function(a,b) return tostring(a) < tostring(b) end)
    return ks
end

function DebugLib.print_tree(list)
    local visited = {}

    local function format_value(v)
        if is_script_block(v) then
            local nvars = (type(v.vars) == "table") and (#v.vars) or 0
            return string.format("<script eval vars=%d func=%s>", nvars, tostring(v.func))
        end
        if type(v) == "string" then return '"' .. v .. '"' end
        return tostring(v)
    end

    local function recurse(node, prefix, is_last)
        if type(node) ~= "table" then
            print(prefix .. (is_last and "└── " or "├── ") .. format_value(node))
            return
        end

        if visited[node] then
            print(prefix .. (is_last and "└── " or "├── ") .. "<cycle>")
            return
        end
        visited[node] = true

        local ks = keys_sorted(node)
        for i, k in ipairs(ks) do
            local v = node[k]
            local last = (i == #ks)
            local branch = last and "└── " or "├── "
            local next_prefix = prefix .. (last and "    " or "│   ")

            if k == "__orig_entry" then
                print(prefix .. branch .. tostring(k) .. " = <orig_entry>")
                if type(v) == "table" then
                    local inner_keys = keys_sorted(v)
                    for j, k2 in ipairs(inner_keys) do
                        local vv = v[k2]
                        local last2 = (j == #inner_keys)
                        local branch2 = last2 and "└── " or "├── "
                        print(next_prefix .. branch2 .. tostring(k2) .. " = " .. format_value(vv))
                    end
                else
                    print(next_prefix .. "└── " .. tostring(v))
                end

            elseif k == "extra" then
                print(prefix .. branch .. tostring(k) .. " =")
                recurse(v, next_prefix, last)
            else
                if type(v) == "table" and not is_script_block(v) and not (#v > 0 and type(v[1]) ~= nil) then
                    print(prefix .. branch .. tostring(k) .. " =")
                    recurse(v, next_prefix, last)
                else
                    print(prefix .. branch .. tostring(k) .. " = " .. format_value(v))
                end
            end
        end
    end

    recurse(list, "", true)
end

return DebugLib