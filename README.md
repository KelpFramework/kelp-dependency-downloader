# Kelp Dependency Downloader
> (c) 2021 KelpFramework, pxav.

![KDD Example screenshot](https://github.com/KelpFramework/kelp-dependency-downloader/blob/master/assets/kdd_screenshot1.PNG)

Kelp Dependency Downloader (KDD) is a simple CLI tool for downloading Spigot, Bukkit, and CraftBukkit using the official Spigot ``BuildTools.jar``. When developing version implementations for example, ``NMS`` code is used, which may not be distributed by Kelp for legal reasons. So everybody has to compile them by themselves, resulting in tedious work for developers.  

KDD is a script you run once, select your desired versions and additional packages (such as documentation) and then wait a few minutes, while 
* The latest ``BuildTools.jar`` is downloaded from the Spigot repository
* The BuildTools are executed for every selected version with the specified parameters (sources, documentation, ...)
* The ``.jar`` files are installed to your local Maven repository.

## How to run

### Requirements
As the script executes the [Spigot BuildTools](https://www.spigotmc.org/wiki/buildtools/) in the background, you will have to install all dependencies listed there:
* ``Git`` available from your command line
* ``Java`` available from your command line (version 1.8 recommended) 


### Downloading
Download the appropriate script for your operating system:
* ``kdd_windows.bat`` for windows systems
* ``kdd_unix.sh`` for Linux and macOS (coming soon)

Or clone the repository 
```shell
git clone https://github.com/KelpFramework/kelp-dependency-downloader.git
cd kelp-dependency-downloader
```

### Executing

On Windows:
```bash
.\kdd_windows.bat
```

On unix systems, you might also have to mark the file as executable:
```shell
chmod +x kdd_unix.sh
./kdd_unix.sh
```

