--[[

local isValid = Email.validate(email)

]]


Email = {}


function Email.validate(str)
    if type(str) ~= "string" then
      return false
    end

    local lastAt = str:find("[^%@]+$")
    local localPart = str:sub(1, (lastAt - 2)) -- get substring before @
    local domainPart = str:sub(lastAt, #str) -- get substring after @

    -- check if split worked
    if not localPart or not domainPart then
      return false
    end

    -- local part max is 64 characters
    -- domains part max is 253 characters
    -- and check @ position
    local localSize = #localPart
    local domainSize = #domainPart
    if localSize > 64 or localSize < 1 or domainSize > 253 or domainSize < 1 or lastAt > 64 then
      return false
    end

    -- quotes are only allowed at the beginning of a the local name
    local quotes = localPart:find("[\"]")
    if type(quotes) == "number" and quotes > 1 then
      return false 
    end

    -- no @ symbols allowed outside quotes
    if localPart:find("%@+") and quotes == nil then
      return false
    end

    -- check for dot in domain part
    -- domains can be valid without dots, but this is highly discouraged and not recommended
    -- otherwise only 1 period in succession allowed
    if not domainPart:find("%.") or domainPart:find("%.%.") or localPart:find("%.%.") then
      return false
    end

    -- email pattern check
    if not str:match("[%w]*[%p]*%@+[%w]*[%.]?[%w]*") then
      return false -- "Email pattern test failed"
    end

    -- all tests passed, email is ok
    return true
end
