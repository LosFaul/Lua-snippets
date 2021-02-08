--[[
Warning:
    size stands for the number of possible states
    so, size has to be 2 or bigger
    number has to be smaller than 2^54 or it's not unseable

    Example at the bottom
]]


FlagsHelper = {}


function FlagsHelper:toNumber(flags, flagData)
    local number = 0
    local factor = 1
    local data, name, size, value
    for i = 1, #flagData do
        data = flagData[i]
        name = data.name
        size = data.size
        value = flags[name]
        number = number + value * factor
        factor = factor * size
    end
    return number
end


function FlagsHelper:toFlags(number, flagData, flags)
    -- flags is optional argument for the case you want to overwirte values of an already existing table
    -- otherwise it will return a new table
    if flags then
        local data, name, size, value
        for i = 1, #flagData do
            data = flagData[i]
            name = data.name
            size = data.size
            value = number % size
            number = (number - value) * (1 / size)
            flags[name] = value
        end
    else
        flags = {}
        local data, name, size, value
        for i = 1, #flagData do
            data = flagData[i]
            name = data.name
            size = data.size
            value = number % size
            number = (number - value) * (1 / size)
            flags[name] = value
        end
        return flags
    end
end


function FlagsHelper:debugPrintFlags(flags)
    for k, v in pairs(flags) do
        print(k, v)
    end
end


-- EXAMPLE --
--[[

local flagData = {
    { name = "a", size = 3},
    { name = "b", size = 2},
    { name = "c", size = 4},
    { name = "d", size = 5},
}

local flags = {
    a = 1,
    b = 0,
    c = 1,
    d = 2,
}

FlagsHelper:debugPrintFlags(flags)

local number = FlagsHelper:toNumber(flags, flagData)
FlagsHelper:toFlags(number, flagData, flags)

FlagsHelper:debugPrintFlags(flags)

]]



