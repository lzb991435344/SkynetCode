-- 每个服务独立, 都需要引入skynet
local skynet = require "skynet"
require "skynet.manager"    -- 引入 skynet.register
local db = {}

local command = {}

function command.get(key)
    print("comman.get:"..key)   
    return db[key]
end

function command.set(key, value)
    print("comman.set:key="..key..",value:"..value) 
    db[key] = value
    local last = db[key]
    return last
end

skynet.start(function()
    print("==========Service2 Start=========")
    skynet.dispatch("lua", function(session, address, cmd, ...)
        print("==========Service2 dispatch============"..cmd)
        local f = command[cmd]      
        if f then
            -- 回应一个消息可以使用 skynet.ret(message, size) 。
            -- 它会将 message size 对应的消息附上当前消息的 session ，
            --以及 skynet.PTYPE_RESPONSE 这个类别，发送给当前消息的来源 source 
            skynet.ret(skynet.pack(f(...))) --回应消息
        else
            error(string.format("Unknown command %s", tostring(cmd)))
        end
    end)
    --可以为自己注册一个别名。（别名必须在 32 个字符以内）
    skynet.register "SERVICE2"
end)

--[[
[:01000002] LAUNCH snlua bootstrap
[:01000003] LAUNCH snlua launcher
[:01000004] LAUNCH snlua cmaster
[:01000004] master listen socket 0.0.0.0:2013
[:01000005] LAUNCH snlua cslave
[:01000005] slave connect to master 127.0.0.1:2013
[:01000004] connect from 127.0.0.1:40660 4
[:01000006] LAUNCH harbor 1 16777221
[:01000004] Harbor 1 (fd=4) report 127.0.0.1:2526
[:01000005] Waiting for 0 harbors
[:01000005] Shakehand ready
[:01000007] LAUNCH snlua datacenterd
[:01000008] LAUNCH snlua service_mgr
[:01000009] LAUNCH snlua main
======Server start=======
[:0100000a] LAUNCH snlua service2
==========Service2 Start=========
==========Service2 dispatch============set
comman.set:key=key1,value:value111111
==========Service2 dispatch============get
comman.get:key1
value111111
[:01000009] KILL self
[:01000002] KILL self


--]]