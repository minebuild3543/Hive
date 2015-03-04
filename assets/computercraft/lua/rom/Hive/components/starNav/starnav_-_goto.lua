--original by: blunty666
--forum post: http://www.computercraft.info/forums2/index.php?/topic/19491-starnav-advanced-turtle-pathfinding-and-environment-mapping/

os.loadAPI("map")
os.loadAPI("starNav")
os.loadAPI("pQueue")

local tArgs = {...}
starNav.goto(tArgs[1], tArgs[2], tArgs[3])
starNav.compactMap()