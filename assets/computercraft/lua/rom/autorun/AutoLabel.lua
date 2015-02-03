--authour: Lupus590
local description = "This script is designed to be run on startup and checks if computers have a label.\n If it does not then it makes one based on several pieces of data which can help identify the computer.\n The format of the resulting lable is '<Advanced|Normal><Turtle|Pocket|Computer><ID>' all within 2 characters (plus id)\nIf the computer already has a label and you want this script to assign a new one then you can run the script with the argument f"
local advance --is the computer an advanced golden computer?
local _type --is the computer a turtle, pocketPC or just a computer?
local function genLabel()

	
	if term.isColour() then --advanced colour PC?
		advance = "A"
	else --but be not advanced
		advance = "N"
	end

	
	if turtle then --turtle?
		_type = "T"
	elseif pocket then --pocketPC?
		_type = "P"
	else --must be normal computer
		_type = "C"
	end
	
	os.setComputerLabel(advance.._type..tostring(os.getComputerID())) --append the id do that the computer has a unique label
end

local function printArgs()
	print("Welcome to lupus590's auto labeling script!")
	textutils.pagedPrint(description)
end


--main
local args = {...} or nil
if args[1] == nil then
	--normal mode
	if os.getComputerLabel() == nil then
		genLabel()
	end
elseif args[1] == "f" or args[1] == "F" then
	--force a re-gen
	genLabel()
	print("Lable set to "..os.getComputerLabel())
else
	printArgs();
end