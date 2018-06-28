#!/usr/bin/lua

--[[
根据服务器 ip 获取对应 mac 地址
]]
local luahtml = require "luahtml"
local os = require "os"

luahtml.head("text/json")

local ip = luahtml.get_client_ip()
local mac = luahtml.get_client_mac(ip)
mac = string.gsub(mac, "%s", "")
print("{\"mac\":\"" .. mac .. "\"}")