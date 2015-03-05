--todo move to hive.lua

--this file calls components of hive that should be run from startup every time
--as the computers startup walks through each file running them one after the other returns, we can combine them as one file (thus, this)
path = "../components/"
shell.run(path.."AutoLabel.lua")
if(turtle) then
	--shell.run(path.."AutoFuel.lua")--better to put this into the turtle api
	loadAPI(path.."turtle.lua")
	turtle = turtle.lua --overeide the default turtle API
end 