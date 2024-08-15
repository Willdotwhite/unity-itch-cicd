# Unity -> Itch Auto Build & Deploy Script

This is a PowerShell script that I use for my Unity game jam projects, and you might want to use it too.

The target audience for this script is the GMTK community for game jams - if you're not in that server, you won't be able to get in contact with me.

> [!IMPORTANT]
> This is only designed for Unity projects on Windows
> You need to install, setup and login to `butler` before this script will work

> [!WARNING]
> Use at your own risk! Run this on a test project before letting it loose on your game.
> (You're allowed to do this before the game jam starts.)
>
> I use it myself, but I'm not responsible if you misuse and abuse this script!

> [!WARNING]
> Also, general game jam advice - build early, build often. Don't wait until the last minute to upload your game!

## Prerequisties

You need to have butler installed: https://itch.io/docs/butler/installing.html

Read the script instructions and change the variables at the top of the file - it should only take about 10 seconds.

## Quickstart

1. Download the `.ps1` file into the root of your project
2. Update the variables at the top of the file
3. Open PowerShell, navigate to your project, and run the script with `.\snapshot-build-and-publish.ps1`

## How it works

1. You run the script when you want to build and deploy your project
2. It copies your _entire_ project into a new 'snapshot' folder
    * The first time this runs it's slow as hell, but it will be faster with repeat runs
3. The script builds and deploys your project from the snapshot in the background, leaving you free to keep working on the main project

> [!TIP]
> The script takes a while - you don't need to wait for it to finish! Let it run in the background while you keep jamming.

## Something's broken!

Please open an issue here. I'm also taking part in the jam this year, so I'll fix what I can and help if I'm free, but if you haven't tested this before Tuesday afternoon then I have no sympathy for you.

If something is fundamentally wrong, I'll update the script. If it's something broken on your machine (e.g. you're not using Unity Hub), then I'll help if I'm free but I can't promise anything.

The script moves from your project folder (`$Source`) into the snapshot folder (`$Destination`). If something crashes, make sure you're back in your project folder before rerunning the script.

Make sure you read the error message you get first. Use at your own risk!

### What about Godot/Unreal/(Something else)?

You're welcome to adapt this script; I'll be too busy to help.

## Credit

All credit goes to James Bacon (beercan1989), who originally wrote this and gave me permission to share this.

It was originally much neater, I've scrunched it into one file for ease of setup.