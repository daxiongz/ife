#!/usr/bin/lua

local luahtml = require "luahtml"
local web = require "web"
local uci = require "uci"
local os  = require "os"
local cjson = require "cjson"
local ubus = require "ubus"
require "common"

local x = uci.cursor()

local file_path ="/etc/config/device_info"

local sn_read = "snread"
local sn = io.popen(sn_read)
sn = sn:read("*all")
sn = string.gsub(sn, "\n", "")

local data = {}

if luahtml.file_exists(file_path) then 
  x:foreach("device_info", "device",
    function(s)
      local line = {}
      line["city_code"] = s["city_code"]
      line["station_id"] = s["station_id"]
      line["station_name"] = s["station_name"]
      line["biz_code"] = s["biz_code"]
      line["province_code"] = s["province_code"]
      line["area_code"] = s["area_code"]
      line["ap_sn"] = sn
      data["ap"] = line
      return true
    end
  )
else
	local line = {}
  line["city_code"] = ""
  line["station_id"] = ""
  line["station_name"] = ""
  line["biz_code"] = ""
  line["province_code"] = ""
  line["area_code"] = ""
  line["ap_sn"] = sn
  data["ap"] = line
end

data = cjson.encode(data)

luahtml.head("text/json")
print("callback(" .. data .. ")")