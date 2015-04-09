--Author: Lupus590

--this is the main program, this is what users will run
--what this program actually does is update and bootstrap the actual program

--check compatibility
--[[
bunch of if statments checking for APIs
	if can't load the api
		if can't download the api
			error? prompt to continue?
]]

shell.run("AutoLabel.lua")

--set aliases for everything (remove the .lua extension and need for file path)	
--shell.setAlias(string alias, string program)

--shell.setAlias() 

--TODO: add an api to the global environment

--TODO:launch the program
	--nest(server)
		--task master
		--drone tracker
	--drone(client)
		--tracking device
		--task executer
	--queen(GUI)

--TODO:error recovery 
--likely: drop into nsh

