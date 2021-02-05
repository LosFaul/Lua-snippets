local sb = createSandbox(
    { print = print }
)

sb:load([[
    print("hello world")
    function test(...)
        print(...)
    end
]])

sb:call("test", 1, 2, 3)
sb:call(sb.env.test, 1, 2, 3)



----------------------------------------------------------------



local envData = {
    __hooks = {
        print = function(sandbox, ...)
            print(sandbox.id, ...)
        end
    }
}

local sandboxData = {
    id = 1337
}


local sb = createSandbox(envData, sandboxData)
sb:load([[
    print("Hello, World!")
]])



----------------------------------------------------------------



local envData = {
    __hooks = {
        print = function(sandbox, ...)
            print(sandbox, ...)
        end
    }
}


local sb = createSandbox(envData)
sb:load([[
    print("Hello, World!")
]])
