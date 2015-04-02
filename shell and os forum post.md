I have a project that I'm working on which looks like it may end up having it's own coroutine manager.

Also, recently I've been looking at other peoples OSs, and how CC multishell and window APIs work (heard some complaints about different things).

Any way, I want to know what I should and should not do in writing an OS/shell. If you have made an OS/shell before, please share you what you've learned. Any essential/popular features?

P.S. I don't plan to add Pre-1.73 support
P.P.S. I'm aware that you can't make a proper OS in CC but that's what every one calls their shell so... yeah.

I've started work on the non-OS parts: http://www.computerc...e-other-things/

My basic design idea is an improved shell with multi-tasking and non-colour.

My Notes
[namedSpoiler=Don'ts]

    Fake loading screen
    File spamming(why have 8 APIs just to get 1 API to function?)
    Sequels e.g. MyOS 2(unless the OS is revamped in GUI/Functionality)
    use default multi-shell nor window API

[/namedSpoiler]

[namedSpoiler= Ideas]
Key:
Not possible
When I develop, these features will be prioritised

General

    multi-shell like interface with options to switch tabs (ctrl-tab? fn keys?) must be non colour compatible
    static program IDs
    inter program communication (via events, one program does a special queue action, perhaps os.message(programID,message), which sends an event to another program, the 2nd program collects the event the normal way)
    speed - default ui as comand line with optional gui
    colours must be "clean and matching"
    everything must be spaced out well - not this
    optional gui
    customisation - UI Colours, language - store config in lua table
    Multilingual - lang files (I will need translators, google is only so good) also due to lua, this will be limited to characters in the ASCII range (use nearest equivalent, é will become e, best of luck with non-latin text)
    found a cool API loader which is compatible with file extensions http://pastebin.com/P5PCiPyg - thanks ElvishJerricco for letting me use this
    remote startup files (take a startup file from another computer via rednet) - I have no idea what this would be useful for
    apiUnloader which allows api's to do stuff 'before they leave' http://www.computerc...__fromsearch__1

Shell

    tab auto-complete
    bash like?
    powershell like 'what if' - this may use alot of sandboxing
    super user mode - the OS tries to protect it's own files but will allow full access if the user types in a password
    hidden file - anything with a file name that starts with a . will be hidden (E.G. .git .meta .*), an argument to the ls command with show these (super user show too?)

[/namedSpoiler]

[namedSpoiler= Learning from others (This is not a name and shame)]
Examples Of What To Do

    CraftBang
    LongOS

Examples Of What Not To Do
[/namedSpoiler]

