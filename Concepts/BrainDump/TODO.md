TODO: everything below
TODO: clean up do to list for readability
TODO: reformat forum post copy for markdown

convert readme, to do list to markdown format

update lama (last forum post said that it was buggy/not working in CC1.63)
combine lama with starNav

make code portable, autorun folder is rom only (everything in autorun needs to move to startup or some other root file or I need to make my own auto run)


licence for below: https://github.com/LeGoldFish/Advance-Turtle-Operating-Environment/blob/master/LICENSE
slot.fuel - an idea from https://github.com/LeGoldFish/Advance-Turtle-Operating-Environment/blob/master/autoprograms/refuel.lua
installer code - from https://github.com/LeGoldFish/Advance-Turtle-Operating-Environment/blob/master/installer
response = http.get(raw.github.com/KingofGamesYami/Advance-Turtle-Operating-Environment/)
	for k, v in pairs( response ) do
		local file = fs.open(k)
		file.writeLine(v)
		file.close()
end


add to do comments to scripts
turtle movement api - make it emit turtle_moved event
turtle task requesting script
task master
drone watcher
tracking script (turtle side)
remote connect - control computers like you are there, use Lyquds' nsh?
lua table for storing user settings
GUI

migrate help docs to CC default location so that they can be loaded by the help program provided by CC?, may have problems with the help docs being in rom
	backup option, have own help program

make wiki on github repo? add one on CC wiki?

this system may become an ~~OS~~ _shell_, I have mixed feelings about that.

multi-threading - http://www.computercraft.info/forums2/index.php?/topic/19908-run-code-in-background/
					https://docs.google.com/document/d/1UU-bSCgLqwAQixldXmDzvEFPACaieph3qs08WreQlZs/edit
					
BONUS: if a printer is detected, offer to print a manual