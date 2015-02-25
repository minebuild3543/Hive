if(!turtle) error("script must be run on a turtle",2) --the 2 tell lua to blame the line that called this script
if(turtle.getFuelLevel() == "unlimited") return --script is useless with unlimited fuel, so exit
print("Warning: automatic refuel is enabled, items may disappear if the turtle runs low on fuel.\n".."To prevent this make sure that the turtles fuel level stays above "..toString(fuelReserveLevel).."\n".."the automatic refuel script will take fuel one at a time until the above value is reached or exceeded.") 
local function autoFuelBackground()
	local fuelReserveLevel = 10
	
	while true do
		if(turtle.getFuelLevel() < fuelReserveLevel) 
			turtle.refuel(1)
		end
		sleep(0.1)
	end
end

coroutine.create(autoFuelBackground)
