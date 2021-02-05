-- Lua 5.1

--[[


[, optional1, optional2, ...]

local sb = createSandbox(environementData[, sandboxData, unloadFunction])

sb:load(code)
sb:destroy()
sb:call(fn, ...)


]]




local type = type
local pairs = pairs
local dummy = function() end


local function isBytecode(code)
    return code:sub(0, 1) == "\27"
end


local function sandboxLoad(self, code, allowBytecode)
    local bytecode = isBytecode(code)
    if bytecode and not allowBytecode then
        print("WARNING: tried to load bytecode, but bytecode is not allowed")
        return false
    end

    if type(code) == "string" then
        code = loadstring(code)
    else
        return false
    end

    if type(code) == "function" then
        local env = self.env
        setfenv(code, env)
        pcall(code)
        return true
    end

    return false
end


local function sandboxDestroy(self)
    self.unload()
    self.env = nil
end


local function sandboxCall(self, fn, ...)
    if type(fn) == "string" then
        pcall(self.env[fn], ...)
    else
        pcall(fn, ...)
    end
end


function createSandbox(envData, sbData, unloadFn)
    local env = { _G = false }
    env._G = env

    local sandbox = {
        id = id,
        env = env,
        load = sandboxLoad,
        destroy = sandboxDestroy,
        unload = unloadFn or dummy,
        call = sandboxCall
    }
    
    if sbData then
        for k, v in pairs(sbData) do
            sandbox[k] = v
        end
    end

    local init = function(sandbox, envData, helper)
        local pairs = helper.pairs
        local type = helper.type

        local function setupFunctions(target, source)
            for k, v in pairs(source) do
                local t = type(v)
                
                if t == "function" then
                    target[k] = v
                elseif t == "table" then
                    if k == "__hooks" then
                        for fn, hook in pairs(v) do
                            target[fn] = function(...) return hook(sandbox, ...) end
                        end
                    else
                        local temp = {}
                        target[k] = temp
                        setupFunctions(temp, v)
                    end
                else -- number, bool, string, userdata, ...
                    target[k] = v
                end
            end
        end

        setupFunctions(_G, envData)
    end
    
    local helper = {
        pairs = pairs,
        type = type
    }

    setfenv(init, env)
    init(sandbox, envData, helper)

    return sandbox
end
