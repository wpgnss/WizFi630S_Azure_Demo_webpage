local fs = require "nixio.fs"
local sys   = require "luci.sys"
local uci  = require "luci.model.uci"

m = Map("azureiot", translate("Azure IoT Hub"))

azure_info = m:section(TypedSection, "cloud_info", translate("Azure IoT Hub Configuration"))
azure_info.addremove = false
azure_info.anonymous = false

-- projectid = azure_info:option(Value, "hostname", translate("Host Name"))
-- projectid.placeholder = "Project ID"

-- deviceid = azure_info:option(Value, "deviceid", translate("Device ID"))
-- deviceid.placeholder = "Device ID"

-- saskey = azure_info:option(Value, "saskey", translate("Shared Access Key"))
-- saskey.placeholder = "SAS token"

cs = azure_info:option(Value, "connectionString", translate("Connection String"))
cs.placeholder = "Connection String"

dev_info = m:section(TypedSection, "end_device", translate("Device information"))
dev_info.addremove = true
dev_info.anonymous = true

dev_name = dev_info:option(Value, "name", translate("Device Name"))
dev_name.placeholder = "Device Name"

devicepath = dev_info:option(Value, "device", translate("Device ID"))
devicepath.placeholder = "Device ID"


start = azure_info:option(Button, "start", translate("Start"))
start.inputstyle = "apply"
start.write = function(self, section)
--	local hostname = uci:get("azureiot", "azure", "hostname")
--	local deviceid = uci:get("azureiot", "azure", "deviceid")
--	local saskey = uci:get("azureiot", "azure", "saskey")
	local connectionstring = uci:get("azureiot", "azure", "connectionString")
	sys.call("echo cs %s > /dev/console" %{ connectionstring  })
	sys.call("/azure/wizfi630s_azure_gateway %s >/dev/null" %{ "/dev/ttyACM0", connectionstring })
end

stop = azure_info:option(Button, "stop", translate("Stop"))
stop.inputstyle = "remove"
stop.write = function(self, section)
--	local dn
--	local dp
--	luci.model.uci.cursor():foreach("azureiot", "end_device", function(s) dn = s.name end)
--	luci.model.uci.cursor():foreach("azureiot", "end_device", function(s) dp = s.device end)

	sys.process.exec({ "/bin/sh", "-c","sleep 1; killall -9 wizfi630s_azure_gateway; sleep 1"}, nil, nil, true)
end

return m