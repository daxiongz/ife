#!/usr/bin/lua

local web = {}

function web.head()
  io.write("Content-Type: application/json\r\n\r\n")
end

function web.lang()

end

function web.cookie_parse(val)
  local t = {}

  for k, v in string.gmatch(val, "(%w+)=(%w+)") do
    t[k] = v
  end

  return t
end

function web.cookie_info( info )
  local cjson = require "cjson"

  local results = {}
  results["code"] = "-5"
  results["result"] = info
  local msg = cjson.encode(results)
  print(msg)
end

function web.check_login()
  local cookie = os.getenv("HTTP_COOKIE")
  
  local x = uci.cursor()

  require "common"
  if not file_exists("/tmp/cookie_info") then

    web.cookie_info("no cookie file!");

    os.exit()
  end

  if cookie ~= nil and cookie ~= ""  then 

    local cookie_table = web.cookie_parse(cookie)
    local id = cookie_table["Id"]

    if id == nil then
      web.cookie_info("no cookie id!")
      os.exit()
    end
    x:set_confdir("/tmp/")
    local exist_id = 0
    x:foreach("cookie_info", "cookie", 
      function(s)
        if s[".name"] == id then
          exist_id = 1
          return false
        else
          exist_id = 0
        end
      end
    )

    if exist_id == 0 then

      web.cookie_info("exist_id:" .. exist_id )
      os.exit()

    end
    
    x:set_confdir("/etc/config/")
  else
    web.cookie_info("cookie is nil or empty!");
    os.exit()
  end
end

function web.tail()
  io.write("}")
end

function web.parse_get(get_str)
  local del = "&"
  local ddel = "="

  if get_str == nil or get_str == "" then
    return nil
  end

  local str = web.url_decode(get_str)

  local results = {}
--  for k, v in string.gmatch(str, "([%w_]+)=([%w_:/. ,-@#|]*)") do
  for k, v in string.gmatch(str, "([%w_%[%]]+)=([^=&?]*)") do
    k = string.gsub(k, "^%s*(.-)%s*$", "%1")
    v = string.gsub(v, "^%s*(.-)%s*$", "%1")
    results[k]=v
  end

  return results
end

function web.url_encode(w)
  pattern="[^%w%d%._%-%* ]"
  s=string.gsub(w,pattern,function(c)
                  local c=string.format("%%%02X",string.byte(c))
                  return c
  end)
  s=string.gsub(s," ","+")
  return s
end

function web.url_decode(w)
  s=string.gsub(w,"+"," ")
  s,n = string.gsub(s,"%%(%x%x)",function(c)
                      return string.char(tonumber(c,16))
  end)
  return s
end
function web.parse_mac(macs)
  local results = {}
  for mac in string.gmatch(macs, "[%x:]+") do
    table.insert(results, mac)
  end
  return results
end

function web.parse_ip(ips)
  local results = {}
  for ip in string.gmatch(ips, "[%x.]+") do
    table.insert(results, ip)
  end
  return results
end

function web.get_line_str(line, split)
  local str = ""
  if not line then
    return str
  end
  for k,v in pairs(line) do
    str = (str == "" and v or str .. split .. v)
  end
  return str
end

-- post_info和get_info为key value对

function web.post_info()
  local msg = io.read("*a")
  return web.parse_get(msg)
end

function web.get_info()
  return web.parse_get(os.getenv("QUERY_STRING"))
end

function web.split(input, delimiter)
  input = tostring(input)
  delimiter = tostring(delimiter)
  if (delimiter=='') then return false end
  local pos,arr = 0, {}
  for st,sp in function() return string.find(input, delimiter, pos, true) end do
    table.insert(arr, string.sub(input, pos, st - 1))
    pos = sp + 1
  end
  table.insert(arr, string.sub(input, pos))
  return arr
end

-- 或取表单提交的信息
function web.post_form()
  local msg = io.read("*a")
  --[[
  local msg = "-----------------------------1067596592519870217973875023\r\n" .. 
    "Content-Disposition: form-data; name=\"action\"\r\n" ..
    "\r\n" ..
    "add\r\n" ..
    "-----------------------------1067596592519870217973875023\r\n" ..
    "Content-Disposition: form-data; name=\"name\"\r\n" ..
    "\r\n" ..
    "123\r\n" ..
    "-----------------------------1067596592519870217973875023\r\n" ..
    "Content-Disposition: form-data; name=\"title\"\r\n"..
    "\r\n"..
    "\r\n"..
    "-----------------------------1067596592519870217973875023\r\n"..
    "Content-Disposition: form-data; name=\"get_password\"\r\n"..
    "\r\n"..
    "1\r\n"..
    "-----------------------------1067596592519870217973875023\r\n" ..
    "Content-Disposition: form-data; name=\"disclaimer\"\r\n" ..
    "\r\n"..
    "0\r\n"..
    "-----------------------------1067596592519870217973875023\r\n"..
    "Content-Disposition: form-data; name=\"auth_type\"\r\n"..
    "\r\n"..
    "0\r\n"..
    "-----------------------------1067596592519870217973875023\r\n"..
    "Content-Disposition: form-data; name=\"logo\"; filename=\"021cf555b379339bf35815d15210fd0d.png\"\r\n"..
    "\r\n"..
    "2222222\r\n"..
    "-----------------------------1067596592519870217973875023\r\n"..
    "Content-Disposition: form-data; name=\"template\"\r\n"..
    "\r\n"..
    "0\r\n"..
    "-----------------------------1067596592519870217973875023\r\n"..
    "Content-Disposition: form-data; name=\"midad_1\"\r\n"..
    "\r\n"..
    "\r\n"..
    "-----------------------------1067596592519870217973875023\r\n"..
    "Content-Disposition: form-data; name=\"midad_2\"\r\n"..
    "\r\n"..
    "\r\n"..
    "-----------------------------1067596592519870217973875023\r\n"..
    "Content-Disposition: form-data; name=\"midad_3\"\r\n"..
    "\r\n"..
    "\r\n"..
    "-----------------------------1067596592519870217973875023\r\n"..
    "Content-Disposition: form-data; name=\"midad_4\"\r\n"..
    "\r\n"..
    "\r\n"..
    "-----------------------------1067596592519870217973875023\r\n"..
    "Content-Disposition: form-data; name=\"midad_5\"\r\n"..
    "\r\n"..
    "\r\n"..
    "-----------------------------1067596592519870217973875023\r\n"..
    "Content-Disposition: form-data; name=\"text_title\"\r\n"..
    "\r\n"..
    "\r\n"..
    "-----------------------------1067596592519870217973875023\r\n"..
    "Content-Disposition: form-data; name=\"text_content\"\r\n"..
    "\r\n"..
    "\r\n"..
    "-----------------------------1067596592519870217973875023\r\n"..
    "Content-Disposition: form-data; name=\"cop\"\r\n"..
    "\r\n"..
    "\r\n"..
    "-----------------------------1067596592519870217973875023\r\n"..
    "Content-Disposition: form-data; name=\"bgcolor\"\r\n"..
    "\r\n"..
    "\r\n"..
    "-----------------------------1067596592519870217973875023\r\n"..
    "Content-Disposition: form-data; name=\"ad_url\"\r\n"..
    "\r\n"..
    "\r\n"..
    "-----------------------------1067596592519870217973875023--"
  ]]
  local boundary = string.match(os.getenv("CONTENT_TYPE"), "boundary=([%w-]+)")
  --local boundary="---------------------------1067596592519870217973875023"

  local data = {}

  local t = web.split(msg, "--" .. boundary)
  for k,v in pairs(t) do
    if v ~= "" and string.sub(v, 1, 2) ~= "--" then
      local _,spos = string.find(v, "Content-Disposition:", 1, true)
      local epos = string.find(v, "\r\n", spos, true)
      local disposition = string.sub(v, spos + 1, epos)

      local n = string.match(disposition, "name=\"([%w_]+)\"")
      --local fn = string.match(disposition, "filename=\"([%w_.-]+)\"")
      local fn = string.match(disposition, "filename=\"([^=&;?]*)\"")
      local d = string.match(v, "\r\n\r\n(.*)\r\n"),fn

      local line = {}
      line["filename"] = fn
      line["name"] = n
      line["data"] = d

      data[n] = line
    end
  end
  return data
end

function web.file_length(name)
  local f = assert(io.open(name, "rb"))
  local len = assert(f:seek("end"))
  f:close()
  return len
end

function web.get_interface_status(result, interface)
  local conn = ubus.connect()
  if not conn then
    result["code"] = "1"
    result["result"] = "Failed to connect to ubusd"
    return
  end

  local status = conn:call("network.interface." .. interface, "status", {})
  result["status"] = status
end

function web.add_cron(enable, mtype, year, mon, mday, hour, min, sec, day)
  if enable == "1" then
    local c = ""
    -- 每天
    if mtype == "1" then
      c = min .. " " .. hour .. " * * * /sbin/reboot"
    -- 每周
    elseif mtype == "2" then
      c = min .. " " .. hour .. " * * " .. day .. " /sbin/reboot"
    -- 每月
    elseif mtype == "3" then
      c = min .. " " .. hour .. " " .. mday .. " * * /sbin/reboot"
    -- 每年
    elseif mtype == "4" then
      c = min .. " " .. hour .. " " .. mday .. " " .. mon .. " * /sbin/reboot"
    end
    os.execute("echo \"" .. c .. "\" >> /etc/crontabs/admin")
  end
end
function web.del_cron(enable, mtype, year, mon, mday, hour, min, sec, day)
  if enable == "1" then
    local c = ""
    -- 每天
    if mtype == "1" then
      c = min .. " " .. hour .. " * * * /sbin/reboot"
      -- 每周
    elseif mtype == "2" then
      c = min .. " " .. hour .. " * * " .. day .. " /sbin/reboot"
      -- 每月
    elseif mtype == "3" then
      c = min .. " " .. hour .. " " .. mday .. " * * /sbin/reboot"
      -- 每年
    elseif mtype == "4" then
      c = min .. " " .. hour .. " " .. mday .. " " .. mon .. " * /sbin/reboot"
    end

    c = string.gsub(c, "/", "\\/")
    c = string.gsub(c, "%*", "\\%*")
    os.execute("a=$(cat /etc/crontabs/admin | sed '/" .. c .. "/d');echo \"$a\" > /etc/crontabs/admin")

  end
end

function web.get_method()
    return os.getenv("REQUEST_METHOD")
end

function web.portal_save_image(section, filename, data)
  local f = io.open("/www/ibox/htmls/portal/" .. section .. "/img/" .. filename, "w+")
  if f then
    f:write(data or "")
    f:close()
  end
end

-- conf 配置文件名称， op 操作，一般为restart 或者reload
function web.ucitrack(conf, op)
    local uci = require("uci")
    local x = uci.cursor()
    if x then
        x:foreach("ucitrack", conf,
                  function(s)
                      local init = s["init"]
                      if init then
                          local cmd  =  "/etc/init.d/" .. init .. " " .. op .. " >/dev/null 2>&1"
                          os.execute(cmd)
                      end
                      local affects = s["affects"]
                      if affects then
                          for k,v in ipairs(affects) do
                              web.ucitrack(v, "restart")
                          end
                      end
                      local exec = s["exec"]
                      if exec then
                          os.execute(exec .. " >/dev/null 2>&1")
                      end
                  end
        )
    end

end

return web
