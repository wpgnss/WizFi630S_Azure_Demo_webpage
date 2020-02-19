local utl = require "luci.util"

module("luci.controller.admin.azureiothub",package.seeall)
function index()
        entry({"admin","azureiothub"}, firstchild(), "Azure IoT hub", 60).dependent=false
        entry({"admin","azureiothub", "config"}, cbi("admin_azureiothub/config", {hideresetbtn=true, hidesavebtn=true}), "Configuration",1)

	entry({"admin", "azureiothub", "dashboard"}, alias("admin", "azureiothub", "dashboard", "tilebox"), _("Realtime"), 7)
	entry({"admin", "azureiothub", "dashboard", "tilebox"}, template("admin_azureiot/dashboard"), _("tile.box"), 1).leaf = true
	entry({"admin", "azureiothub", "dashboard", "sensordata"}, call("get_sensor_data")).leaf = true

end



function get_sensor_data()
	
	local sensor = utl.ubus("gyro", "gyro", {}) or {}

	if type(sensor) == "table" then		
		luci.http.prepare_content("application/json")
		luci.http.write("[[")
		luci.http.write(sensor.x)
		luci.http.write(',')
		luci.http.write(sensor.y)
		luci.http.write(',')
		luci.http.write(sensor.z)
		luci.http.write("]]")
	end
end