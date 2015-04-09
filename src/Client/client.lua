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
	else
		local ok, err = pcall(function ()
			client.main()
		end)
		if not ok then
			client.crash(err)
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

	sleep(2.5)

	client.core.connect()
	client.core.menu()
end

function client.core.connect()
	local modemside = misc.find("modem")
	if not modemside then
		printError("No modem attached!")
	else
		rendet.open(modemside)
	end

	rednet.broadcast("client_connect", "hivesystem")
	serverid, message = rednet.receive("hivesystem", 2)
	if serverid then
		return true
	else
		printError("Can't connect to server")
	end
end

function client.draw.menuitems()
	--##############--##############--##############--

	--// Jobs
	draw.box(3, 14, 3, 3, " ", "cyan", "cyan")
	draw.box(3, 14, 4, 1, " ", "cyan", "cyan")
	draw.texta("Job List",6, 4, false, "white", "cyan")

	--// Destinations
	draw.box(3, 14, 8, 3, " ", "cyan", "cyan")
	draw.box(3, 14, 9, 1, " ", "cyan", "cyan")
	draw.texta("Destinations",4, 9, false, "white", "cyan")

	--// Turtle List
	draw.box(19, 14, 3, 3, " ", "cyan", "cyan")
	draw.box(19, 14, 4, 1, " ", "cyan", "cyan")
	draw.texta("Turtles List", 20, 4, false, "white", "cyan")

	--// Statistics
	draw.box(19, 14, 8, 3, " ", "cyan", "cyan")
	draw.box(19, 14, 9, 1, " ", "cyan", "cyan")
	draw.texta("Statistics", 21, 9, false, "white", "cyan")

	--// Job Online Store
	draw.box(35, 14, 3, 3, " ", "cyan", "cyan")
	draw.box(35, 14, 4, 1, " ", "cyan", "cyan")
	draw.texta("Jobs Store", 37, 4, false, "white", "cyan")
end

function client.core.menu()
	col.screen("white")
	client.draw.bar("Menu")
	client.draw.menuitems()

	while true do
		local args = { os.pullEvent() }
		if args[1] == "timer" then
			client.draw.bar("Menu")
		end
	end
end

-- Start Code:
client.getapi()