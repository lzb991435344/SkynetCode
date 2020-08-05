local skynet = require "skynet"
-- local socket = require "socket"
-- 新版本
local socket = require "skynet.socket"

-- 读取客户端数据, 并输出
local function echo(id)
    -- 每当 accept 函数获得一个新的 socket id 后，并不会立即收到这个 socket 上的数据。这是因为，我们有时会希望把这个 socket 的操作权转让给别的服务去处理。
    -- 任何一个服务只有在调用 socket.start(id) 之后，才可以收到这个 socket 上的数据。
    socket.start(id)

    while true do
        -- 读取客户端发过来的数据
        local str = socket.read(id)
        if str then
            -- 直接打印接收到的数据
            print(str)
        else
            socket.close(id)
            return
        end
    end
end

skynet.start(function()
    print("==========Socket1 Start=========")
    -- 监听一个端口，返回一个 id ，供 start 使用。
    local id = socket.listen("127.0.0.1", 8888)
    print("Listen socket :", "127.0.0.1", 8888)

    socket.start(id , function(id, addr)
            -- 接收到客户端连接或发送消息()
            print("connect from " .. addr .. " " .. id)

            -- 处理接收到的消息
            echo(id)

        end)
    --可以为自己注册一个别名。（别名必须在 32 个字符以内）
    -- skynet.register "SOCKET1"
end)

--server   ./skynet ../skynetCode/exam03/config
--client   ./3rd/lua/lua  ../skynetCode/exam03/client1.lua 

--[[
[:01000002] LAUNCH snlua bootstrap
[:01000003] LAUNCH snlua launcher
[:01000004] LAUNCH snlua cmaster
[:01000004] master listen socket 0.0.0.0:2013
[:01000005] LAUNCH snlua cslave
[:01000005] slave connect to master 127.0.0.1:2013
[:01000004] connect from 127.0.0.1:41012 4
[:01000006] LAUNCH harbor 1 16777221
[:01000004] Harbor 1 (fd=4) report 127.0.0.1:2526
[:01000005] Waiting for 0 harbors
[:01000005] Shakehand ready
[:01000007] LAUNCH snlua datacenterd
[:01000008] LAUNCH snlua service_mgr
[:01000009] LAUNCH snlua main
======Server start=======
[:0100000a] LAUNCH snlua socket1
==========Socket1 Start=========
Listen socket : 127.0.0.1   8888
[:01000009] KILL self
[:01000002] KILL self
connect from 127.0.0.1:34966 6
Hello world
connect from 127.0.0.1:34978 7
Hello world



--]]