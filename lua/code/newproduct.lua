#!/usr/bin/lua


local web = require "web"
local luahtml = require "luahtml"
local os = require "os"
local cjson = require "cjson"

-- luahtml.head("text/html")

-- 先获取所处目录路径

local root = io.popen("pwd")
root = root:read("*all")
root, tmp = string.gsub(root, "%s", "")
root = root .. "/"

-- 获取参数中product_type用户类型（1-普通用户；2-医护人员）和os_type终端类型
local product_type = luahtml.request_val("type", "")
local os_type = luahtml.get_os()

-- 寻找app.conf文件，读取相应配置
local conf_file = root .. "comm/conf/app.conf"

if not luahtml.file_exists(conf_file) then
	luahtml.open("", "app.conf is not exist")
  return
end

local f = io.open(conf_file, "r")
local data = f:read("*all")
f:close()
-- print("data:" .. data)
data = cjson.decode(tostring(data))

local app_conf = data[os_type]
-- print("app_conf: " .. app_conf)
local app_file_name = ""
local app_file_path = ""
local app_plist_file_path = ""
if not luahtml.is_empty(app_conf) then
	app_file_name = app_conf["filename"]
	app_file_path = app_conf["filepath"]
end
-- print("filename:" .. app_file_name .. " filepath:" .. app_file_path)

-- 向后端发送ubus请求
local client_ip = luahtml.get_client_ip()
local client_mac = luahtml.get_client_mac(client_ip)
local platform_os = ""
local app_version = ""
if os_type == "android" then
	platform_os = "1"
	if app_file_path ~= "" then
		local start = "android_"
		local j, k = string.find(app_file_path, start)
		app_version = string.sub(app_file_path, k+1, -5)
	end
elseif os_type == "ios" then
	platform_os = "2"
	if app_file_path ~= "" then
		local start = "ios_"
		local j, k = string.find(app_file_path, start)
		app_version = string.sub(app_file_path, k+1, -5)
	end
end
local ubus_hltlc = 'ubus call hltlc_ubus b13_request \'{"mac":"' .. client_mac .. '","platform_os":"' .. platform_os .. '","appversion":"' .. app_version .. '","type":"' .. product_type .. '","ip":"' .. client_ip .. '"}\''
-- luahtml.open("", ubus_hltlc)
os.execute(ubus_hltlc)


-- 根据os_type区分安卓和苹果；再根据product_type区分用户类型，确定app下载地址
local app_url = ""
local abs_url2 = "/www/helian.doc/htdocs/llapp/android_b.apk"
if	os_type == "android" then
	if product_type == "1" and luahtml.file_exists(app_file_path) then 
		app_url = "http://" .. string.gsub(app_file_path, "/www/helian.doc/htdocs", "app.helianhealth.com")
		luahtml.open(app_url)
	elseif product_type ~= "1" and luahtml.file_exists(abs_url2) then
		app_url = "http://app.helianhealth.com/llapp/android_b.apk"
		luahtml.open(app_url)
	else
		luahtml.open("", "no android app version")
	end
else
	if product_type == "2" then
		app_url = "https://itunes.apple.com/app/id1058193989"
		luahtml.open(app_url)
	else
		app_url = "https://itunes.apple.com/app/id1054847254"
		luahtml.open(app_url)
	end
end


