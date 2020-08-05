local skynet = require "skynet"
local gateserver = require "snax.gateserver"
--local netpack = require "netpack"
--local common = require "common"

local connection = {}   -- fd -> connection : { fd , ip }
local handler = {}

local agentlist = {}

-- 当一个完整的包被切分好后，message 方法被调用。这里 msg 是一个 C 指针、sz 是一个数字，表示包的长度（C 指针指向的内存块的长度）。
function handler.message(fd, msg, sz)
    print("===========gate handler.message============"..fd)
    -- common:dump(connection[fd])

    local c = connection[fd]
    local agent = agentlist[fd]
    if agent then
        -- skynet.redirect(agent, c.client, "client", 1, msg, sz)
        print("接收到客户端消息,传给agent服务处理")
    else
        print("没有agent处理该消息")
    end
end

function handler.connect(fd, addr)
    print("===========gate handler.connect============")
    local c = {
        fd = fd,
        ip = addr,
    }
    -- common:dump(c)
    -- 保存客户端信息
    connection[fd] = c

    -- 马上允许fd 接收消息(由于下面交给service1处理消息,所以可以在service1准备好再调用)
    -- 这样可能导致客户端发来的消息丢失,因为service1未准备好的情况下,无法处理消息
    gateserver.openclient(fd)

    agentlist[fd] = skynet.newservice("service1")
    skynet.call(agentlist[fd], "lua", "start", { fd = fd, addr = addr })
end

function handler.disconnect(fd)
    print(fd.."-断开连接")
end

function handler.error(fd, msg)
    print("异常错误")
end

gateserver.start(handler)

--[[
--server   ./skynet ../skynetCode/exam07/config


[:01000002] LAUNCH snlua bootstrap
[:01000003] LAUNCH snlua launcher
[:01000004] LAUNCH snlua cmaster
[:01000004] master listen socket 0.0.0.0:2013
[:01000005] LAUNCH snlua cslave
[:01000005] slave connect to master 127.0.0.1:2013
[:01000004] connect from 127.0.0.1:60058 4
[:01000006] LAUNCH harbor 1 16777221
[:01000004] Harbor 1 (fd=4) report 127.0.0.1:2526
[:01000005] Waiting for 0 harbors
[:01000005] Shakehand ready
[:01000007] LAUNCH snlua datacenterd
[:01000008] LAUNCH snlua service_mgr
[:01000009] LAUNCH snlua main
======Server start=======
[:0100000a] LAUNCH snlua socket1
==========Socket Start=========
Listen socket : 127.0.0.1   8888
[:0100000b] LAUNCH snlua mygate
[:0100000b] Listen on 127.0.0.1:8888
[:01000009] KILL self
[:01000002] KILL self
===========gate handler.connect============
[:0100000c] LAUNCH snlua service1
==========Service1 Start=========
==========Service1 dispatch============start
service1 CMD.start
===========gate handler.message============6
接收到客户端消息,传给agent服务处理
===========gate handler.message============6
接收到客户端消息,传给agent服务处理
===========gate handler.message============6
接收到客户端消息,传给agent服务处理
===========gate handler.message============6
接收到客户端消息,传给agent服务处理
===========gate handler.message============6
接收到客户端消息,传给agent服务处理



--client  ./3rd/lua/lua  ../skynetCode/exam07/client1.lua 

Request:    1
Request:    2
i lonr w
Request:    3
i am yu ^H^Hou 
Request:    4
11111111
Request:    5



--]]
