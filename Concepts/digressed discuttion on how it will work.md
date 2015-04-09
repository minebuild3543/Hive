

I'll be honest, hive has not been fully designed.

I guess it would be: (in automated setups)
craftOS shell startup file -> read file to find previous state/which componet of the program was running -> start related compont

In most cases this would likely be:
If turtle: drone program
if computer: nest program (server code)
if pocket: remote control program

I have more notes on paper with me, will try to dump them into github later today, it will be a markdown file called: WARNING, RAW BRAIN DUMP
@TheOnlyCreator
TheOnlyCreator commented 14 hours ago

How do they communicate with each other?
@lupus590
Owner
lupus590 commented 14 hours ago

Normal CC rednet, I want to use the infrastructure people will already have.

I have an Idea of bit shifting the communications to protect them from other programs using the same channels/hackers.
@TheOnlyCreator
TheOnlyCreator commented 14 hours ago

What happens when the distance is more than the one allowed by rednet?
@lupus590
Owner
lupus590 commented 14 hours ago

when drones take a task they save a copy of it, the only rednet communicationss out of the drone is then progress updates (or error reports). if the nest does not hear from a drone for a time (5 seconds so far is the plan) then that drone is marked as MIA (with last know position displayed) and the player is notified, the player can then decide to start a search and rescue or wait for the drone to get back in range.

After a drone completes a task, it polls the server for more, if it can't connect, it will go back to the nest. (or all drones return to nest before taking a new task, not decided which yet)
@TheOnlyCreator
TheOnlyCreator commented 14 hours ago

Which file should I run to initialize it? When I run autorun it errors on line 11
@lupus590
Owner
lupus590 commented 14 hours ago

none of my code is ready for use, it's all ideas at the moment
@lupus590
Owner
lupus590 commented 14 hours ago

that WARNING, RAW BRAIN DUMP file is now a folder, will upload when complete
@TheOnlyCreator
TheOnlyCreator commented 14 hours ago

OK. I can actually write it from scratch. Can I implement IPnet with it. It would be easier and threr would not be a problem with ranges.
@lupus590
Owner
lupus590 commented 14 hours ago

the problem with that would be comparability with offline players, you can do that in development, but I would like a rednet fallback at least
