-- 加载依赖模块
local io = require("io")
http = require("socket.http")
local ltn12 = require("ltn12")
local cjson = require "cjson"
require "logging"
require "nixio"
local uci = require "uci"

function log(level, message)
    local logger=logging.new(function(self,level,message)
    return true
    end)
    logger:setLevel(logging.WARN)
    require"logging.file"
    local logger = logging.file("/tmp/log/dc_cloud.log","%Y%m%d %X")
    if level == "info" then
        logger:info(message)
    elseif level == "debug" then
        logger:debug(message)
    elseif level == "error" then
        logger:error(message)
    elseif level == "warn" then
        logger:warn(message)
    elseif level == "fatal" then
        logger:fatal(message)
    end

end

--判断table是否为空
function table_is_empty(t)
	return _G.next(t) == nil
end

--执行系统命令，返回执行结果
function dc_system(n)
    local h = io.popen(n, "r")
    local ss = h:read("*all")
    h:close()
    return ss
end

--执行ubus命令
function do_ubus(module, func, msg)
	local conn = ubus.connect()
	if not conn then
		error("Failed to connect to ubusd")
		return 1
	end

	local status = conn:call(module, func, msg)

	conn:close()
	
	return 0
end

-- 根据用户mac查找用户ip
function mac2ip(mac)
	local cmd = "cat /proc/dc/dc_station_list | grep -i "..mac.." | awk '{print $1}'"
	local ip = dc_system(cmd)
	return string.sub(ip, 0, string.len(ip)-1)
end

-- 根据用户ip查找用户mac
function ip2mac(ip)
    local cmd = "cat /proc/dc/dc_station_list | grep "..ip.." | awk '{print $2}'"
    local mac = dc_system(cmd)
    return string.sub(mac, 0, string.len(mac)-1)
end

--删除字符串前后的空格
function dels(str)
    assert(type(str)=="string")
    return string.match(str,"%s*(.-)%s*$")
end

-- 定义sleep函数
--n：秒
function sleep(n)
    os.execute("sleep " .. n)
end

-- 定义usleep函数                                                            
--n：微妙                                                                     
function usleep(n)                                                                     
    os.execute("usleep " .. n)                                                          
end

--执行系统命令，返回状态
--0：正常
--非0：异常
function system(n)
    local s1= os.execute(n)
    return s1
end

--判断网络模式 网桥还是路由
function is_netmode_bridge()                                                      
        local cmd = "uci get network.globals.netbridge | awk '{printf \"%s\",$1}'"
        local result = dc_system(cmd)       
        if result == "1" then
                return true 
        else                
                return false
        end
end

function get_time()                                   
        local time=os.date("*t",os.time())                                                                              
	local tab={year=time.year, month=time.month, day=time.day, hour=time.hour,min=time.min,sec=time.sec,isdes=false}
	return os.time(tab)
end

function is_pppoe_if()
	local cmd = "ifconfig | grep ppp | wc -l"
	local num = dc_system(cmd)
	num = string.sub(num, 0, string.len(num)-1)
	if tonumber(num) == 0 then
		return false
	else
		return true
	end 
end

--[[
--获取 上行口 地址
function wan_ip()
    local interface
    if is_netmode_bridge() then
        -- interface = "br-lan"
        interface = dc_system("route | grep default | awk '{print $8}'")
        -- 去掉字符串的换行符
        interface = string.gsub(interface, "^%s*(.-)%s*$", "%1")
        if interface == "" or interface == nil then
        interface = "br-lan"
        end
        nixio.syslog("err", "interface = "..interface)
    elseif is_pppoe_if() then
    	interface = dc_system("ifconfig | grep ppp | awk '{print $1}'")
    	interface = string.sub(interface, 0, string.len(interface)-1)	
    else
        interface = "eth0"
    end
    local wanip=dc_system("ifconfig " .. interface .. " |grep -w 'inet'|awk '{print $2}'|awk -F: '{print $2}'")
    return string.sub(wanip, 0, string.len(wanip)-1)
end
]]--
function get_ip_by_interface(interface)
    local ipaddr = ""
    ipaddr = dc_system("ifconfig " .. interface .. " 2>/dev/null | grep -w 'inet' | awk '{print $2}' | awk -F: '{print $2}'")
    ipaddr = string.gsub(ipaddr, "^%s*(.-)%s*$", "%1")
    return ipaddr or ""
end
function wan_ip()
    local interface = ''
    local cmd = ""
    local wan_ip=""
    local x = uci.cursor()
    local netbridge = x:get("netbridge","globals","netbridge")

    if netbridge == "0" or netbridge == "2" then -- 路由或旁路
        local proto = x:get("network", "wan", "proto")

        if proto == "pppoe" then
            interface = "pppoe-wan"
        else
            interface = x:get("network", "wan", "ifname")
        end
        wan_ip = get_ip_by_interface(interface)
    elseif netbridge == "1" then -- 网桥
        interface = "br-lan"
        wan_ip = get_ip_by_interface(interface)
    elseif netbridge == "3" then -- 双WAN
        local wan_proto = x:get("network", "wan", "proto")
        local wan2_proto = x:get("network", "wan2", "proto")
        local wan_inter = ""
        local wan2_inter = ""
        local wan_ipaddr = ""
        local wan2_ipaddr = ""

        if wan_proto == "pppoe" then
            wan_inter = 'pppoe-wan'
        else
            wan_inter = x:get("network", "wan", "ifname")
        end
        if wan2_proto == "pppoe" then
            wan2_inter = "pppoe-wan2"
        else
            wan2_inter = x:get("network", "wan2", "ifname")
        end

        wan_ipaddr = get_ip_by_interface(wan_inter)
        wan2_ipaddr = get_ip_by_interface(wan2_inter)

        wan_ip = (wan_ipaddr == "" and "" or (wan_ipaddr .. ",")) .. wan2_ipaddr
    end
    return wan_ip or ""
end

--判断文件是否存在
--返回值false:文件不存在，true:文件存在
function file_exists(path)
    local file = io.open(path, "rb")
    if file then file:close() end
    return file ~= nil
end

-- 检测路径是否目录  
function is_dir(sPath)  
    if type(sPath) ~= "string" then return false end  
  
    local response = os.execute( "cd " .. sPath )  
    if response == 0 then  
        return true  
    end  
    return false  
end 

--获取网关sn
function get_sn()
    local sta = file_exists("/etc/sn")
    if sta ~= true then
        return ""
    end
    local file_name="/etc/sn"
    local file,msg=io.open(file_name, "r")
    if not file then nixio.syslog("err",msg) end
    local sn=file:read("*l")
    file:close()
    if sn == nil or sn == "" or sn == " " then
        return ""
    end
    return sn
end

--获取网关mac
function get_mac()
    local mac = dc_system("ifconfig eth0 | awk '/eth0/{print $NF}'")
    if not mac or mac == "" then
        return ""
    end
    return string.sub(mac, 0, string.len(mac)-1)
end

--截取str中字符串buf之前的字符串
--返回截取的字符串
function splitstr(str, buf)
    local s1=string.find(str, buf)
    return string.sub(str, 0, s1-1)
end

--字符串中替换子窜串
--str:字符串
--restr:str中的子串
--buff：新的子串
function replastr(str, restr, buff)
    return string.gsub(str, restr, buff)
end

--将str按delimiter分割
--按最小情况分割
--返回table类型
function string.split(str, delimiter)
    if str==nil or str=='' or delimiter==nil then
        return nil
    end

    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end


--调用系统命令，将str分割执行系统命令返回值，并返回一个分割后的table类型
--str适用" "分割和'.'分割
function system_table(cmd, str)
    local table1={}
    local value=dc_system(cmd)
    if str ~= " " then
        local str_t=string.gsub(value, "[\n]", " ")
        for str_t in string.gmatch(str_t, "(%w+)" .. str) do
            table.insert(table1, str_t)
        end
    else
        local str_t=string.gsub(value, "[\n]", str)
        for str_t in string.gmatch(str_t, "(%S+) ") do
            table.insert(table1, str_t)
        end
    end	
    return table1 	
end

--状态文件读取行标志，返回读取值
--path:文件的路径
function read_file(path)
    local file,msg=io.open(path,"r")
    if not file then nixio.syslog("err", "read_file:" .. msg) return end
    local flag=file:read("*l")
    file:close()
    return flag
end


--文件写入
--path:文件的路径
--value:写入文件的值，覆盖原文件
function write_file(path,value)
    local file,msg=io.open(path,"w")
    if not file then nixio.syslog("err", "write_file:" .. msg) return end
    file:write(value)
    file:close()
end


function wget(url, path, option)
-- 	local cmd="wget --no-use-server-timestamps " .. option .. " \"" .. url .. "\" -O \"" .. path .. "\""
    local cmd="wget -c -t 10 -T 15 " .. url .. " -O " .. path
    nixio.syslog("info", "wget cmd :" .. cmd)
    local state=system(cmd)
    nixio.syslog("info", "wget ret state :" .. state)
    return state
end

--发送到cgi
function get_to_cgi(host,port,cgi_url)
    local u="http://" .. host .. ":" .. port .. cgi_url 
    local t = {}
    local r, c, h = http.request{
    url = u,
    sink = ltn12.sink.table(t)}
    return r, c, h, table.concat(t)
end

--GW-云平台交互状态处理接口
function connectflag_handling()
    local flag = 0
    if file_exists("/tmp/dc_cloud_connect.flag") then
        flag=read_file("/tmp/dc_cloud_connect.flag")

        if tonumber(flag) > 0 then
            flag=flag -1
            write_file("/tmp/dc_cloud_connect.flag",flag)
        end
    else
        flag = 0
        write_file("/tmp/dc_cloud_connect.flag",flag)
    end

-- 如果连接失败，则置为逃生模式
    if tonumber(flag) == 0 then
        local cmd = "uci get dc_config.portal_st.authType | awk '{printf \"%s\", $1}'"
        local result = dc_system(cmd)
        if result ~= "0" then
            nixio.syslog("info", "clould connection interrupt, so set auth type unauthed!")
            cmd = "ubus call package.dc_frame recv_auth_type_info '{\"data_from_cgi\":\"{\\\"AUTH_TYPE\\\":\\\"0\\\"}\"}'"
            os.execute(cmd)
            cmd = "uci set /etc/config/dc_config.portal_st.authType=0"
            os.execute(cmd)
        else
            nixio.syslog("info", "clould connection interrupt, setted auth type unauthed yet!!!")
        end

        cmd = "ubus call package.dc_frame recv_param_custom_info '{\"param_custom_enable\":0,\"param_custom_params\":\"\"}'"
        os.execute(cmd)
    end
end

--向管控模块发送连接、断开云平台消息
function op_connectflag(flag)
	local cmd = "ubus call package.dc_frame recv_cloud_connectflag '{\"flag\":"..flag.."}'"
	nixio.syslog("info", "connect flag: "..flag)
	return os.execute(cmd)
end

--发送消息到云平台
function send_http_msg(msg,host,port)
    local data = {}
    local response = {}
    --将表数据编码成json字符串
    local msg_t = cjson.encode(msg);
    nixio.syslog("info",msg_t);
    -- 发送HTTP消息
    res, code = http.request{
        url = "http://" ..host.. ":" ..port.. "/dunyun_gws/rest/upload",  
        method = "POST",  
        headers =   
        {  
            ["Content-Type"] = "application/x-www-form-urlencoded",  
            ["Content-Length"] = #msg_t,  			
        },  
        source = ltn12.source.string(msg_t),
        sink = ltn12.sink.table(response)
    }
    -- 处理HTTP响应消息
    response = table.concat(response)
    if response ~= nil and response ~= "" and string.find(response, "msg_type") ~= nil  then
        nixio.syslog("info",response)
        data=cjson.decode(response)
        if type(data) == 'table' then
            -- 如果连接上云平台（第一次连接或从未连接编程连接），向管控模块发送上线消息
            if file_exists("/tmp/dc_cloud_connect.flag") then
                local flag=read_file("/tmp/dc_cloud_connect.flag")
                if tonumber(flag) == 0 then
                    op_connectflag(1)
                end
            else
                op_connectflag(1)
            end

            if msg["msg_type"] == "B01" then
                write_file("/tmp/dc_cloud_connect.flag",9)
            end
            
            return res, data
        else
            if msg["msg_type"] == "B01" then
                connectflag_handling()
            end
        end
        return res, nil
		
    else
        if msg["msg_type"] == "B01" then
            connectflag_handling()
        end
        if code == "timeout" then
            return res, code 
        else
            return res, nil
        end

    end
end

function get_devmodel_version()
    local file_name="/devinfo/sysinfo"
    local file,msg=io.open(file_name, "r")
    if not file then nixio.syslog("err",msg) end
    local str=file:read("*l")
    file:close()
    if str == nil or str == "" or str == " " then
        return ""
    end
    local sstr=string.sub(str,string.find(str,'=')+1, string.len(str))
    return string.sub(sstr, 0 ,string.find(sstr, "V")-1),string.sub(sstr, string.find(sstr, "V"),string.len(sstr))

end
