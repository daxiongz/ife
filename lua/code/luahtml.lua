#!/usr/bin/lua

local luahtml = {}
-- POST和GET的使用，需要引入web模块
local os = require "os"
local web = require "web"

-- local POST = web.post_info()
local GET = web.get_info()

function luahtml.head(type)
	io.write("Content-Type: " .. type .. "; charset: utf-8;\r\n\r\n")
end
-- 获取服务器 ip
function luahtml.get_client_ip()
	if os.getenv("HTTP_X_FORWARDED_FOR") ~= nil and os.getenv("HTTP_X_FORWARDED_FOR") ~= "" then
		return os.getenv("HTTP_X_FORWARDED_FOR")
	elseif os.getenv("HTTP_CLIENT_IP") ~= nil and os.getenv("HTTP_CLIENT_IP") ~= "" then
		return os.getenv("HTTP_CLIENT_IP")
	else
		return os.getenv("REMOTE_ADDR")
	end
end
-- 根据参数 ip 在 proc 系统中获取对应 mac
function luahtml.get_client_mac(client_ip)
	local cmd = "cat /proc/net/arp | grep " .. client_ip .. " | awk '{print $4}'"
	local data = io.popen(cmd)
	data = data:read("*all")
	return data
end
-- 检测文件是否存在,true--存在，false--不存在
function luahtml.file_exists(path)
    local file = io.open(path, "rb")
    if file then file:close() end
    return file ~= nil
end
-- 获取 br-lan 接口的 IP 地址
function luahtml.get_server_ip()
	local cmd = '/sbin/ifconfig br-lan | sed -n \'s/^ *.*addr:\\([0-9.]\\{7,\\}\\) .*$/\\1/p\''
	local data = io.popen(cmd)
	data = data:read("*all")
	return data
end
-- 向某一个地址发起请求
function luahtml.fetch_page(url, params)
	local rurl = url
	if params ~= nil then
		rurl = url .. "?" .. params
	end
	local r, c, h = http.request{
		url = rurl
	}
end
-- 打开一个地址
function luahtml.open(url, info)
	io.write("Content-Type: text/html; charset: utf-8;\r\n\r\n")
	if info == nil then
		print("<script>window.location.href='" .. url .. "'</script>")
		-- print("<h2>" .. url .. "</h2><script>window.open('" .. url .. "')</script>")
	else
		print("<h3>" .. info .. "</h3>")
	end
end
-- 检测一个变量是否为空，true - 空，false - 非空
function luahtml.is_empty(val)
	return val == nil or val == ""
end
-- 获取设备类型
function luahtml.get_os()
	local val = ""
	if os.getenv("HTTP_USER_AGENT") ~= nil and os.getenv("HTTP_USER_AGENT") ~= "" then
		local agent = os.getenv("HTTP_USER_AGENT")
		-- luahtml.open("", agent)
		if string.find(agent, "Android") ~= nil or string.find(agent, "Linux") ~= nil then
			val = "android"
		elseif string.find(agent, "iPad") ~= nil or string.find(agent, "iPhone") ~= nil or string.find(agent, "iPod") ~= nil then
			val = "ios"
			-- print("val:" .. val)
		end
	elseif os.getenv("QUERY_STRING")~= nil and os.getenv("QUERY_STRING") ~= "" then
			local query = os.getenv("QUERY_STRING")
			-- print("4")
			if query ~= nil and query ~= "" then
				val = GET["os"]
				-- print("val:" .. val)
			end
	else
		-- print(5)
		val = ""
	end

	-- print("val:" .. val)
	-- luahtml.open("", val)
	return val
end
-- 获得app类型
function luahtml.get_apptype()
	local app_type = ""
	local query = os.getenv("QUERY_STRING")
	if query ~= nil and query ~= "" then
		local rex = "%A" .. "type" .. "%A"
		if string.find(query, rex) ~= nil then
			app_type = GET[val]
		end
	else
		param = 1
	end
	return app_type
end
-- 获取 GET/POST 方式 传递的参数值
function luahtml.request_val(val, def)
	local param
	local extra
	if def == nil then
		extra = ""
	else 
		extra = def
	end
	-- print("1:" .. extra)
	local query = os.getenv("QUERY_STRING")
	if query ~= nil and query ~= "" then
		-- print("2" .. query)
		param = GET[val]
	else
		param = extra
	end
	-- print("param: " .. param) 
	return param
end

return luahtml