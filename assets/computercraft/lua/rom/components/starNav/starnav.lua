--Testing version 1.0.1
--original by: blunty666
--forum post: http://www.computercraft.info/forums2/index.php?/topic/19491-starnav-advanced-turtle-pathfinding-and-environment-mapping/


os.loadAPI("map")
os.loadAPI("pQueue")

local graph = map.new("starNav")
local facing
local sensorSide

local function findSensor()
	if not sensorSide then
		for _, side in ipairs({"left", "right"}) do
			if peripheral.isPresent(side) then
				local methods = peripheral.getMethods(side)
				for _, name in pairs(methods) do
					if name == "sonicScan" then
						sensorSide = side
						break
					end
				end
			end
			if sensorSide then break end
		end
	end
end
	

local function vectorEquals(a, b)
	return a.x == b.x and a.y == b.y and a.z == b.z
end

local function adjacent(u)
	return {
		u + vector.new(0, 0, 1),
		u + vector.new(-1, 0, 0),
		u + vector.new(0, 0, -1),
		u + vector.new(1, 0, 0),
		u + vector.new(0, 1, 0),
		u + vector.new(0, -1, 0),
	}
end

local function getFacing()
	local i = 0
	while turtle.detect() do
		if i == 4 then
			if turtle.up() then
				i = 0
			else
				error("help I'm trapped in a ridiculous place")
			end
		else
			turtle.turnRight()
			i = i + 1
		end
	end
	local p1 = {gps.locate()}
	if #p1 == 3 then
		p1 = vector.new(unpack(p1))
	else
		error("no gps signal - phase 1")
	end
	i = 0
	while not turtle.forward() do
		if i > 5 then error("couldn't move to determine direction") end
		i = i + 1
		sleep(1)
	end
	local p2 = {gps.locate()}
	turtle.back()
	if #p2 == 3 then
		p2 = vector.new(unpack(p2))
	else
		error("no gps signal - phase 2")
	end
	local dir = p2 - p1
	if dir.x == 1 then
		facing = 3
		return 3
	elseif dir.x == -1 then
		facing = 1
		return 1
	elseif dir.z == 1 then
		facing = 0
		return 0
	elseif dir.z == -1 then
		facing = 2
		return 2
	else
		error("could not determine direction - phase 3")
	end
end

local function setFacing(newFacing)
	local delta = newFacing - facing
	if math.abs(delta) == 2 then
		turtle.turnRight()
		turtle.turnRight()
	elseif math.abs(delta) == 1 then
		if delta < 0 then
			turtle.turnLeft()
		else
			turtle.turnRight()
		end
	elseif math.abs(delta) == 3 then
		if delta < 0 then
			turtle.turnRight()
		else
			turtle.turnLeft()
		end
	end
	facing = newFacing
	return newFacing
end

local function detect(currPos, adjPos)
	local dir = adjPos - currPos
	if dir.y == 1 then
		return turtle.detectUp()
	elseif dir.y == -1 then
		return turtle.detectDown()
	elseif dir.x == 1 then
		setFacing(3)
		return turtle.detect()
	elseif dir.x == -1 then
		setFacing(1)
		return turtle.detect()
	elseif dir.z == 1 then
		setFacing(0)
		return turtle.detect()
	elseif dir.z == -1 then
		setFacing(2)
		return turtle.detect()
	else
		return false
	end
end

local function detectAll(currPos)
	for _, pos in ipairs(adjacent(currPos)) do -- better order of checking directions
		local detected = detect(currPos, pos)
		local blocked = graph:get(pos)
		if detected and not blocked then
			graph:set(pos, 1)
		elseif not detected and blocked then
			graph:set(pos, nil)
		end
	end
end

local function scan(currPos)
	if sensorSide then
		local changed = peripheral.call(sensorSide, "sonicScan")
		for _, blockInfo in ipairs(changed) do
			local pos = currPos + vector.new(blockInfo.x, blockInfo.y, blockInfo.z)
			local blocked = graph:get(pos)
			if blockInfo.type ~= "AIR" and not blocked then
				graph:set(pos, 1)
			elseif blockInfo.type == "AIR" and blocked then
				graph:set(pos, nil)
			end
		end
	else
		detectAll(currPos)
	end
	graph:save()
end

local function move(currPos, adjPos)
	if not detect(currPos, adjPos) then
		local dir = adjPos - currPos
		if dir.y == 1 then
			return turtle.up()
		elseif dir.y == -1 then
			return turtle.down()
		else
			return turtle.forward()
		end
	else
		return false
	end
end

local function h(a, b) -- 1-norm/manhattan metric
	return math.abs(a.x - b.x) + math.abs(a.y - b.y) + math.abs(a.z - b.z)
end

local function d(a, b)
	return ((graph:get(a) or graph:get(b)) and math.huge) or h(a, b)
end

local function makePath(nodes, start, startEnd, goalStart, goal)
	local current, path = startEnd, {}
	while not vectorEquals(current, start) do
		table.insert(path, current)
		current = nodes:get(current)[1]
	end
	current = goalStart
	while not vectorEquals(current, goal) do
		table.insert(path, 1, current)
		current = nodes:get(current)[1]
	end
	table.insert(path, 1, goal)
	return path
end

local function aStar(start, goal)

	-- node data structure is {parent node, true cost from startNode/goalNode, whether in closed list, search direction this node was found in, whether in open list}
	local nodes = map.new()
	nodes:set(start, {start + vector.new(0, 0, -1), 0, false, "start", true})
	nodes:set(goal, {goal + vector.new(0, 0, -1), 0, false, "goal", true})

	local openStartSet = pQueue.new()
	openStartSet:insert(start, h(start, goal))

	local openGoalSet = pQueue.new()
	openGoalSet:insert(goal, h(start, goal))

	local yieldCount = 0
	local currQueue, currSide, lastNode, switch = openStartSet, "start", "none", false

	while not openStartSet:isEmpty() and not openGoalSet:isEmpty() do -- need to improve checks for no possible route

		yieldCount = yieldCount + 1
		if yieldCount > 200 then
			os.queueEvent("yield")
			os.pullEvent()
			yieldCount = 0
		end

		if switch then
			if currSide == "start" then
				currSide = "goal"
				currQueue = openGoalSet
			elseif currSide == "goal" then
				currSide = "start"
				currQueue = openStartSet
			end
			lastNode = "none"
		end

		local current, value = currQueue:pop()
		local currNode = nodes:get(current)
		local parent = current - currNode[1]
		currNode[3], currNode[5], switch = true, false, true

		for _, neighbour in ipairs(adjacent(current)) do
			if not graph:get(neighbour) then
				local nbrNode, newNode = nodes:getOrSet(neighbour, {current, currNode[2] + d(current, neighbour), false, currSide, false})
				if switch and (lastNode == "none" or vectorEquals(lastNode, neighbour)) then
					switch = false
				end

				local newCost = currNode[2] + d(current, neighbour)
				if not newNode then
					if currSide ~= nbrNode[4] then
						return makePath(nodes, start, (currSide == "start" and current) or neighbour, (currSide == "start" and neighbour) or current, goal)
					end
					if newCost < nbrNode[2] then
						if nbrNode[5] then
							currQueue:remove(neighbour, vectorEquals)
							nbrNode[5] = false
						end
						nbrNode[3] = false
					end
				end

				if (newNode or (not nbrNode[5] and not nbrNode[3])) and newCost < math.huge then
					nbrNode[1] = current
					nbrNode[2] = newCost
					nbrNode[4] = currNode[4]
					nbrNode[5] = true
					local preHeuristic = h(neighbour, start)
					currQueue:insert(neighbour, newCost + preHeuristic + 0.0001*(preHeuristic + parent.length(parent:cross(neighbour - current))))
				end
			end
		end
		lastNode = current

	end

	return false

end

function goto(x, y, z)
	getFacing()
	local currPos = {gps.locate()}
	if #currPos == 3 then
		currPos = vector.new(unpack(currPos))
	else
		error("couldn't determine location")
	end
	local goal = vector.new(tonumber(x), tonumber(y), tonumber(z))
	findSensor()
	scan(currPos)
	if graph:get(goal) then error("goal is blocked") end
	local path = aStar(currPos, goal)
	if not path then
		error("no known path to goal")
	end
	while not vectorEquals(currPos, goal) do
		local movePos = table.remove(path)
		if detect(currPos, movePos) then
			scan(currPos)
			if graph:get(goal) then error("goal is blocked") end
			path = aStar(currPos, goal)
			if not path then
				error("no known path to goal")
			end
		else
			while not move(currPos, movePos) do
				sleep(1) -- better obstacle detection
			end
			currPos = movePos
		end
	end
end

function compactMap()
	local x, y = term.getCursorPos()
	local dots = 0
	print("evaluating nodes")
	graph:loadAll()
	local toRemove = {}
	for gX, yzGrid in pairs(graph.map) do
		for gY, zGrid in pairs(yzGrid) do
			for gZ, grid in pairs(zGrid) do
				os.queueEvent("yield")
				os.pullEvent()
				term.setCursorPos(1, y-1)
				dots = (dots + 1) % 3
				print("evaluating nodes", string.rep(".", dots))
				for pX, yzPos in pairs(grid) do
					for pY, zPos in pairs(yzPos) do
						for pZ, value in pairs(zPos) do
							local pos = vector.new(16*gX + pX, 16*gY + pY, 16*gZ + pZ)
							local surrounded = true
							for _, s in ipairs(adjacent(pos)) do
								if not graph:get(s) then
									surrounded = false
									break
								end
							end
							if surrounded then
								table.insert(toRemove, pos)
							end
						end
					end
				end
			end
		end
	end
	print("found ", #toRemove, " nodes to compact")
	print("compacting")
	local x, y = term.getCursorPos()
	local count, dots = 0, 0
	for _, pos in ipairs(toRemove) do
		count = count + 1
		if count > 250 then
			os.queueEvent("yield")
			os.pullEvent()
			term.setCursorPos(1, y-1)
			dots = (dots + 1) % 3
			print("compacting", string.rep(".", dots))
			count = 0
		end
		graph:set(pos, nil)
	end
	print("done compacting")
	graph:save()
end