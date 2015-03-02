--original by: blunty666
--forum post: http://www.computercraft.info/forums2/index.php?/topic/19491-starnav-advanced-turtle-pathfinding-and-environment-mapping/


local files = {
	starNav = "BCk9q0EB",
	goto = "aaxFVEPn",
	map = "1MZDyZYS",
	pQueue = "PYbpYrfx",
}

for fileName, pasteCode in pairs(files) do
	shell.run("pastebin get "..pasteCode.." "..fileName)
end