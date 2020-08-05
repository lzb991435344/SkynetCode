local skynet = require "skynet"
local socket = require "skynet.socket"

local function echo(id)
    -- 每当 accept 函数获得一个新的 socket id 后，并不会立即收到这个 socket 上的数据。这是因为，我们有时会希望把这个 socket 的操作权转让给别的服务去处理。
    -- 任何一个服务只有在调用 socket.start(id) 之后，才可以收到这个 socket 上的数据。
    socket.start(id)

    while true do
        local str = socket.read(id)
        if str then
            print("client say:"..str)
            -- 把一个字符串置入正常的写队列，skynet 框架会在 socket 可写时发送它。
            socket.write(id, str)
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
    -- skynet.register "SOCKET2"
end)




--server  ./skynet ../skynetCode/exam04/config
--client  ./3rd/lua/lua  ../skynetCode/exam04/client2.lua

--[[
 
[:01000002] LAUNCH snlua bootstrap
[:01000003] LAUNCH snlua launcher
[:01000004] LAUNCH snlua cmaster
[:01000004] master listen socket 0.0.0.0:2013
[:01000005] LAUNCH snlua cslave
[:01000005] slave connect to master 127.0.0.1:2013
[:01000004] connect from 127.0.0.1:42510 4
[:01000006] LAUNCH harbor 1 16777221
[:01000004] Harbor 1 (fd=4) report 127.0.0.1:2526
[:01000005] Waiting for 0 harbors
[:01000005] Shakehand ready
[:01000007] LAUNCH snlua datacenterd
[:01000008] LAUNCH snlua service_mgr
[:01000009] LAUNCH snlua main
======Server start=======
[:0100000a] LAUNCH snlua socket2
==========Socket1 Start=========
Listen socket : 127.0.0.1   8888
[:01000009] KILL self
[:01000002] KILL self
connect from 127.0.0.1:36406 6
client say:Hello world
client say:i am a boy


--client
server says: Hello world
i am a boy
server says: i am a boy



--]]