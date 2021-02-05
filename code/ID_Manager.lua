--[[


-- Creating an Id manager
local IdManagerXyZ = createIdManager(100)

-- get a free id
local id = IdManagerXyZ:get()

-- free id ids
IdManagerXyZ:free(xyzId)

-- get amout of free ids left
local leftIDs = IdManagerXyZ:getLeftIDs()

-- reset
IdManagerXyZ:reset()


]]

local function get(self)
    local stack, pointer = self.stack, self.stackPointer
    if pointer < 1 then
        return false
    end
    self.stackPointer = pointer - 1
    return stack[pointer]
end


local function free(self, id)
    local stack, pointer = self.stack, self.stackPointer + 1
    self.stackPointer = max
    if pointer > self.max then
        return
    end
    stack[pointer], self.stackPointer = id, pointer
end


local function getLeftIDs(self)
    return self.stackPointer
end


local function reset(self)
    local stack, max = self.stack, self.max
    for i = 1, max do
        stack[i] = max - i
    end
end


function createIDManager(max)
  local stack = {}  
  local self = {
    -- variables
    max = max,
    stack = stack,
    stackPointer = max,
    -- methods
    get = get,
    free = free,
    getLeftIDs = getLeftIDs,
    reset = reset
  }
  self:reset()
  return self
end
