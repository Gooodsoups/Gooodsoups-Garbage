local CalcLib = {}

local function shallow_copy(t)
    if type(t) ~= "table" then return t end
    local out = {}
    for k,v in pairs(t) do out[k] = v end
    return out
end

local function is_script_block(v)
    return type(v) == "table" and v.eval == true and type(v.func) == "function"
end

local function keys_sorted(t)
    local ks = {}
    for k in pairs(t) do table.insert(ks, k) end
    table.sort(ks, function(a,b) return tostring(a) < tostring(b) end)
    return ks
end

local function entries_shallow_equal(a, b)
    if type(a) ~= "table" or type(b) ~= "table" then
        return a == b
    end
    -- compare keys sets
    local ka = {}
    local kb = {}
    for k in pairs(a) do ka[k] = true end
    for k in pairs(b) do kb[k] = true end
    for k in pairs(ka) do if not kb[k] then return false end end
    for k in pairs(kb) do if not ka[k] then return false end end
    -- compare values shallowly
    for k in pairs(ka) do
        local va = a[k]
        local vb = b[k]
        if type(va) == "table" and type(vb) == "table" then
            -- if both script-blocks compare func identity and vars shallowly
            if is_script_block(va) and is_script_block(vb) then
                if tostring(va.func) ~= tostring(vb.func) then return false end
                local va_vars = va.vars or {}
                local vb_vars = vb.vars or {}
                -- simple numeric/primitive compare for vars (shallow)
                if #va_vars ~= #vb_vars then return false end
                for i=1,#va_vars do if tostring(va_vars[i]) ~= tostring(vb_vars[i]) then return false end end
            else
                -- fallback: compare tostring
                if tostring(va) ~= tostring(vb) then return false end
            end
        else
            if tostring(va) ~= tostring(vb) then return false end
        end
    end
    return true
end

function CalcLib.clamp(value, minv, maxv)
    if minv == nil or maxv == nil then
        return nil
    end
    if minv > maxv then minv, maxv = maxv, minv end
    if value < minv then return minv end
    if value > maxv then return maxv end
    return value
end

function CalcLib.lerp(a, b, t)
    return a + (b - a) * t
end

function CalcLib.unlerp(a, b, v)
    if a == b then return 0 end
    return (v - a) / (b - a)
end

function CalcLib.map(v, a1, b1, a2, b2)
    if a1 == b1 then return nil end
    return a2 + (v - a1) * ((b2 - a2) / (b1 - a1))
end

function CalcLib.map_clamp(v, a1, b1, a2, b2)
    local t = CalcLib.unlerp(a1, b1, v)
    if t <= 0 then return a2 end
    if t >= 1 then return b2 end
    return CalcLib.lerp(a2, b2, t)
end

function CalcLib.sign(x)
    if x > 0 then return 1 elseif x < 0 then return -1 else return 0 end
end

function CalcLib.approx_equal(a, b, eps)
    eps = eps or 1e-9
    return math.abs(a - b) <= eps
end

function CalcLib.wrap(value, minv, maxv)
    local size = maxv - minv
    if size == 0 then return minv end
    local v = (value - minv) % size
    if v < 0 then v = v + size end
    return minv + v
end

function CalcLib.smoothstep(a, b, t)
    t = CalcLib.unlerp(a, b, t)
    if t <= 0 then return 0 end
    if t >= 1 then return 1 end
    return t * t * (3 - 2 * t)
end

function CalcLib.smootherstep(a, b, t)
    t = CalcLib.unlerp(a, b, t)
    if t <= 0 then return 0 end
    if t >= 1 then return 1 end
    return t * t * t * (t * (t * 6 - 15) + 10)
end

function CalcLib.deg_to_rad(d) return d * (math.pi / 180) end
function CalcLib.rad_to_deg(r) return r * (180 / math.pi) end

function CalcLib.dist(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function CalcLib.hyp(dx, dy)
    return math.sqrt(dx * dx + dy * dy)
end

function CalcLib.clamp_int(n, minv, maxv)
    return math.floor(CalcLib.clamp(n, minv, maxv) + 0.5)
end

function CalcLib.combine_calculate(list)
    if #list == 0 then return {} end

    local root = nil
    local cursor = nil

    for idx, entry in ipairs(list) do
        local reps = entry.repeats or 1
        local node_payload = shallow_copy(entry)
        node_payload.repeats = nil

        for r = 1, reps do
            local node = {}
            for k, v in pairs(node_payload) do
                if is_script_block(v) then
                    local ok, result = pcall(v.func, v.vars)

                    if not ok then
                        error("Failed to evaluate script block")
                    end

                    node[k] = result
                else
                    node[k] = v 
                end
            end

            if r == 1 then
                local orig = shallow_copy(entry)
                if orig.repeats then
                    orig.repeats = entry.repeats
                end
                node.__orig_entry = orig
            end

            if not root then
                root = node
                cursor = root
            else
                cursor.extra = node
                cursor = node
            end
        end
    end

    return root or {}
end

function CalcLib.retrieve_calculate(list, allow_repeats)
    if list == nil then return {} end
    if allow_repeats == nil then allow_repeats = true end

    local out = {}
    local cur = list

    while cur do
        local has_real = false
        for k in pairs(cur) do
            if k ~= "extra" and k ~= "__orig_entry" then has_real = true; break end
        end
        if not has_real and not cur.__orig_entry then
            cur = cur.extra
        else
            if allow_repeats and type(cur.__orig_entry) == "table" and cur.__orig_entry.repeats and cur.__orig_entry.repeats > 1 then
                table.insert(out, shallow_copy(cur.__orig_entry))
                local skip = cur.__orig_entry.repeats - 1
                local next_node = cur
                for i=1, skip do
                    if next_node and next_node.extra then
                        next_node = next_node.extra
                    else
                        next_node = nil
                        break
                    end
                end
                if next_node then cur = next_node.extra else cur = nil end
            elseif allow_repeats then
                local base_entry = {}
                for k, v in pairs(cur) do
                    if k ~= "extra" and k ~= "__orig_entry" then base_entry[k] = v end
                end
                
                local count = 1
                local look = cur.extra
                while look do
                    local look_entry = {}
                    for k, v in pairs(look) do
                        if k ~= "extra" and k ~= "__orig_entry" then look_entry[k] = v end
                    end
                    if entries_shallow_equal(base_entry, look_entry) then
                        count = count + 1
                        look = look.extra
                    else
                        break
                    end
                end
                if count > 1 then
                    local to_insert = shallow_copy(base_entry)
                    to_insert.repeats = count
                    table.insert(out, to_insert)
                    for i = 1, count do
                        if cur then cur = cur.extra end
                    end
                else
                    table.insert(out, base_entry)
                    cur = cur.extra
                end
            else
                local entry = {}
                for k, v in pairs(cur) do
                    if k ~= "extra" and k ~= "__orig_entry" then entry[k] = v end
                end
                table.insert(out, entry)
                cur = cur.extra
            end
        end
    end

    return out
end

function CalcLib.get_random_items(list, amount, seed)
    local finallist

    local n = #list
    if n <= amount then
        return list
    end

    local result = {}
    local used = {}

    while #result < amount do
        local idx = math.floor(pseudorandom(seed) * n) + 1
        if not used[idx] then
            table.insert(result, list[idx])
            used[idx] = true
        end
    end

    return result
end

return CalcLib