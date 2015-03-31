-A positioning sytem (persistem position tracking)
-A map explorer, helps path finding
	For example,
	
local map = {}
map.x = {}
map.x.y = {}
map.x.y.z = true or false depending on wether the block is air or not

Each time a block is excavated, it sends the coordinates to the main server, which updates the main map, which notifies the clients of the change.
To cmunicate, we can use IPnet. The concept is ready, but the debugging is not. Anyway I have some vacation, which means coding.
