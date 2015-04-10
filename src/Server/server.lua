--[[

	Name: Hive -> Turtle Automation System
	Type: Server
	Author: DannySMc
	Platform: Lua Virtual Machine
	CCType: Advanced Computer
	Dependencies: Wireless Modem, HTTP Enabled.

	Shared Database Store:
	+ hive -> list = Will list all jobs saved to the job store.
	+ hive -> download = Will download a job and save it to the server.
	+ hive -> upload = Will allow you to upload a job from the server to the job store.

	Server Connections API:
	(FORMAT: function name -> args -> output)
	+ hive_core_connect -> username, password -> "false" (failed) clienthash if worked.
	+ hive_core_disconnect -> clienthash -> "true" or "false"
	+ 

]]

-- Variables:
--[[
	Change the variable below "emulator" to test on emulators
]]
emulator = true
nTries = 0
server = {}
server.__index = server
server.draw = {}
server.draw.__index = server.draw
server.core = {}
server.core.__index = server.core
ccsysurl = "https://ccsystems.dannysmc.com/ccsystems.php"

-- Code:

function server.getapi()
	-- Grab the API
	local ok, err = pcall( function()
		-- Check for http
		if http then
			aa = aa or {}
			local a = http.get("https://vault.dannysmc.com/lua/api/dannysmcapi.lua") -- url
			a = a.readAll()
			local env = {}
			a = loadstring(a)
			local env = getfenv()
			setfenv(a, env)
			local status, err = pcall(a, unpack(aa))
			if (not status) and err then
				printError("Error loading api")
				return false
			end
			local returned = err
			env = env
			_G["progutils"] = env
		else
			printError("HTTP needs to be enabled!")
			return false
		end
	end)
	-- try 3 times to download API.
	if not ok then
		if nTries == 3 then
			print("Api failed to download 3 times, running shell instead.")
			sleep(2.5)
			term.clear()
			term.setCursorPos(1,1)
			shell.run("shell")
		else
			nTries = nTries + 1
			print(err)
			print("Failed to get api, re-trying...")
			sleep(1)
			server.getapi()
		end
	else
		-- run core program in protected call to catch any errors and direct them to server.crash(error_message)
		local ok, err = pcall(function ()
			server.main()
		end)
		if not ok then
			server.crash(err)
		end
	end
end

function server.crash(err)
	-- This is just temporary.

	col.screen("white")
	server.draw.bar("Crash")
	for k, v in ipairs(data.wordwrap(err, 51)) do
		draw.texta(v, 1, 2+k, false, "cyan", "white")
	end

	sleep(2)
	os.reboot()
end