--[[

	Name: Hive -> Turtle Automation System
	Type: Client
	Author: DannySMc
	Platform: Lua Virtual Machine
	CCType: Advanced Computer
	Dependencies: Wireless Modem, HTTP Enabled.

	Shared Database Store:
	+ hive -> list = Will list all jobs saved to the job store.
	+ hive -> download = Will download a job and save it to the server.
	+ hive -> upload = Will allow you to upload a job from the server to the job store.

]]

-- Variables:
nTries = 0
client = {}
client.__index = client
client.draw = {}
client.draw.__index = client.draw
client.core = {}
client.core.__index = client.core
ccsysurl = "https://ccsystems.dannysmc.com/ccsystems.php"

-- Code:

function client.getapi()
	local ok, err = pcall( function()
		if http then
			aa = aa or {}
			local a = http.get("https://vault.dannysmc.com/lua/api/dannysmcapi.lua")
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
			client.main()
		else
			printError("HTTP needs to be enabled!")
			return false
		end
	end)
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
			client.getapi()
		end
	end
end

function client.draw.bar(screenname)
	draw.box(1, 51, 1, 1, " ", "grey", "grey")
	draw.texta("Hive:", 1, 1, false, "cyan", "grey")
	draw.texta(screenname, 7, 1, false, "white", "grey")
	draw.texta(misc.time(), 47, 1, false, "lime", "grey")
end

function client.main()
	col.screen("white")
	local logo = paintutils.loadImage("/Hive/src/Assets/logo.lua")
	paintutils.drawImage(logo, 8, 4)
	draw.textc(" Created by HiveDevTeam", 19, false, "red", "white")


	while true do
		local args = { os.pullEvent() }
	end
end

function client.core.menu()
	col.screen("white")
	client.draw.bar("Menu")

	while true do
		local args = { os.pullEvent() }
	end
end




-- Start Code:
client.getapi()