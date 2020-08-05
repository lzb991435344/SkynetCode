-- 每个服务独立, 都需要引入skynet
local skynet = require "skynet"

-- 这里可以编写各种服务处理函数

skynet.start(function()
        print("==========Service1 Start=========")
        -- 这里可以编写服务代码，使用skynet.dispatch消息分发到各
        --个服务处理函数（后续例子再说）
end)


--[[
[:01000002] LAUNCH snlua bootstrap
[:01000003] LAUNCH snlua launcher
[:01000004] LAUNCH snlua cmaster
[:01000004] master listen socket 0.0.0.0:2013
[:01000005] LAUNCH snlua cslave
[:01000005] slave connect to master 127.0.0.1:2013
[:01000004] connect from 127.0.0.1:40698 4
[:01000006] LAUNCH harbor 1 16777221
[:01000004] Harbor 1 (fd=4) report 127.0.0.1:2526
[:01000005] Waiting for 0 harbors
[:01000005] Shakehand ready
[:01000007] LAUNCH snlua datacenterd
[:01000008] LAUNCH snlua service_mgr
[:01000009] LAUNCH snlua main
======Server start=======
[:0100000a] LAUNCH snlua service1
==========Service1 Start=========
[:01000009] KILL self
[:01000002] KILL self



--]]