local skynet = require "skynet"
local mysql = require "skynet.db.mysql"
​



skynet.start(function()
    local function on_connect(db)
        skynet.error("on_connect")
    end
    local db=mysql.connect({
        host="127.0.0.1",
        port=3306,
        database="jol",
        user="root",
        password="087536",
        max_packet_size = 1024 * 1024,
        on_connect = on_connect
    })
    if not db then
        skynet.error("failed to connect")
    else
        skynet.error("success to connect to mysql server")    
    end
   
    db:disconnect() --关闭连接
end)