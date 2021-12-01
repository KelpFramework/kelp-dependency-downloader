:: This batch script is used to download spigot, bukkit and craftbukkit
:: using the official spigot BuildTools. This script assumes that you have
:: JAVA (Recommended: Java 1.8) and GIT installed on your system and available
:: from your command line. If Git is not available, the BuildTools will manually
:: download a portable version of Git.

@echo off

SET COMPILE_DOCS=1
SET COMPILE_SOURCES=0
SET COMPILE_CRAFTBUKKIT=1
SET COMPILE_CHANGES_ONLY=0

:: The name of the BuildTools file on your system. When the BuildTools are
:: downloaded from the Spigot Jenkins repo, you can rename them by changing
:: this variable.
SET LOCAL_FILE_NAME="BuildTools.jar"

:: When compiling the versions, the script creates a subfolder containing even
:: more sub-folders for each individual version. You can change the name of this
:: directory here. But please note that if you plan to contribute your changes to
:: GitHub again, remember to not push this directory as only "SpigotBuildTools/"
:: is added to the .gitignore file.
SET LOCAL_FOLDER_NAME="SpigotBuildTools"

:: The URL from where to download the latest BuildTools.
SET LATEST_BUILD_TOOLS_DOWNLOAD=https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar

:: An array of all versions needed for development with Kelp.
:: Version.ID      = The name of this version used by the --rev parameter
::                   of the build tools to say which version you would like to
::                   install.
:: Version.Compile = 1 if the version should be compiled/downloaded by this script,
::                   0 if not. This usually only affects the Full installation mode
::                   as those values subject to change during the setup process of
::                   a custom installation either.
SET VERSIONS[0].id=1.8.8
SET VERSIONS[0].compile=1

SET VERSIONS[1].id=1.9.4
SET VERSIONS[1].compile=1

SET VERSIONS[2].id=1.10.2
SET VERSIONS[2].compile=1

SET VERSIONS[3].id=1.11.2
SET VERSIONS[3].compile=1

SET VERSIONS[4].id=1.12.2
SET VERSIONS[4].compile=1

SET VERSIONS[5].id=1.13.2
SET VERSIONS[5].compile=1

SET VERSIONS[6].id=1.14.4
SET VERSIONS[6].compile=1

SET VERSIONS[7].id=1.15.2
SET VERSIONS[7].compile=1

SET VERSIONS[8].id=1.16.5
SET VERSIONS[8].compile=1

SET VERSIONS[9].id=1.17
SET VERSIONS[9].compile=1

SET VERSIONS[10].id=1.17.1
SET VERSIONS[10].compile=1

SET VERSIONS[11].id=1.18
SET VERSIONS[11].compile=1

:: The maximum index of the versions array.
:: This is needed by the for loops and should replace magic values.
SET VERSION_MAX_INDEX=11

ECHO Welcome to Kelp Dependency Manager.

:: todo: Add 'recommended' preset installing documentation but not sources

GOTO DOWNLOAD_LATEST_BUILD_TOOLS

:: Queries the preferred installation mode of the user.
:INSTALL_MODE_SELECTION
ECHO.
ECHO.
ECHO.
ECHO   _  __    _        ____
ECHO  ^| ^|/ /   ^| ^|       \ \ \
ECHO  ^|  / ___^| ^|_ __    \ \ \
ECHO  ^|  ^< / _ \ ^| _ \    ^> ^> ^>
ECHO  ^| . \  __/ ^| ^|_) ^|  / / /
ECHO  ^|_^|\_\___^|_^| .__/  /_/_/     dependency downloader
ECHO             ^| ^|
ECHO             ^|_^|
ECHO Welcome to Kelp Dependency Downloader. A simple CLI tool for
ECHO downloading CraftBukkit with the official Spigot BuildTools.
ECHO.
ECHO.
ECHO.
ECHO Please select your installation preferences
ECHO [a] Install all packages
ECHO    This includes the .jar files of all Spigot, Bukkit and CraftBukkit versions
ECHO    used by Kelp as well as their sources and documentation packages. This allows you
ECHO    to read the bukkit documentation directly from your IDE.
ECHO [c] Custom installation
ECHO    Select which packages and versions to install.

ECHO.

:: Give the user the choice of either pressing A or C
:: This sets the ERRORLEVEL variable to either 1 or 2.
CHOICE /c ac
IF ERRORLEVEL 2 (
    GOTO CUSTOM_INSTALLATION
)

IF ERRORLEVEL 1 (
    GOTO FULL_INSTALLATION
)

:: Install all versions and additional packages including craftbukkit, sources, and docs.
:FULL_INSTALLATION
ECHO.
ECHO.
ECHO OK. All packages will be installed.
ECHO.
ECHO.
:: iterate all existing versions
FOR /L %%n IN (0, 1, %VERSION_MAX_INDEX%) DO (
   CALL ECHO Installing version %%VERSIONS[%%n].id%%
   :: create version sub-folder and copy BuildTools there.
   CALL MKDIR %%VERSIONS[%%n].id%%

   :: copy BuildTools to version subfolder to be able to properly run them
   :: from there.
   CALL COPY %%LOCAL_FILE_NAME%% %%VERSIONS[%%n].id%%\%%LOCAL_FILE_NAME%%

   :: navigate to version subfolder
   CALL CD %%VERSIONS[%%n].id%%

   :: actually run the BuildTools in the version sub-folder.
   CALL JAVA -jar BuildTools.jar --rev %%VERSIONS[%%n].id%% --compile craftbukkit --generate-docs --generate-source

   :: navigate back to the BuildTools folder defined by %LOCAL_FOLDER_NAME%
   CALL CD ..
)
GOTO END_APPLICATION

:: Ask the user which packages to install.
:CUSTOM_INSTALLATION
ECHO.
ECHO.
ECHO OK. Only the configured packages will be installed.

:: Enable delayed variable expansion to be able to modify the
:: compile state of the versions inside the for-loop.
SETLOCAL ENABLEDELAYEDEXPANSION

FOR /L %%n IN (0, 1, %VERSION_MAX_INDEX%) DO (
    CALL ECHO.
    CALL ECHO Install %%VERSIONS[%%n].id%%? [Y / n]
    CHOICE /c yn /n

    IF ERRORLEVEL 2 (
        SET VERSIONS[%%n].compile=0
        CALL ECHO %%VERSIONS[%%n].id%% won't be compiled!
    )

    IF ERRORLEVEL 1 (
        SET VERSIONS[%%n].compile=1
        CALL ECHO %%VERSIONS[%%n].id%% will be compiled!
    )
)

ECHO.
ECHO OK. Versions selected. You can now define the additional packages you want to install.

ECHO.
ECHO.
ECHO Do you want to download the documentation of the Bukkit API?
ECHO This allows you to for example directly see what a method does
ECHO inside your IDE. But it will require some more disk space.
ECHO Recommended value: Y
CHOICE
IF ERRORLEVEL 2 (
    SET COMPILE_DOCS=0
    ECHO OK. Documentation won't be downloaded.
) ELSE (
    SET COMPILE_DOCS=1
    ECHO OK. Documentation will be downloaded.
)

ECHO.
ECHO.
ECHO Do you want to download the sources of the Bukkit API?
ECHO This allows you to read the Bukkit source code without
ECHO having to decompile it or go the Bukkit git repository.
ECHO Recommended value: Y
CHOICE
IF ERRORLEVEL 2 (
    SET COMPILE_SOURCES=0
    ECHO OK. Sources won't be downloaded.
) ELSE (
    SET COMPILE_SOURCES=1
    ECHO OK. Sources will be downloaded.
)

ECHO.
ECHO.
ECHO Do you want to download the CraftBukkit API?
ECHO This allows you to use NMS in your projects, which is needed if
ECHO you want to work with packets for example. If you want to
ECHO write code for the Kelp Version implementations or compile the Kelp
ECHO project yourself, this package IS REQUIRED.
ECHO Recommended value: Y
CHOICE
IF ERRORLEVEL 2 (
    SET COMPILE_CRAFTBUKKIT=0
    ECHO OK. Sources won't be downloaded.
) ELSE (
    SET COMPILE_CRAFTBUKKIT=1
    ECHO OK. Sources will be downloaded.
)

ECHO.
ECHO.
ECHO Do you want to download changes only?
ECHO This will check if there has been an update to the
ECHO desired files before installing them. Only those changed
ECHO files are installed, the rest remains untouched.
ECHO Recommended value: N
CHOICE
IF ERRORLEVEL 2 (
    SET COMPILE_CHANGES_ONLY=0
    ECHO OK. Sources won't be downloaded.
) ELSE (
    SET COMPILE_CHANGES_ONLY=1
    ECHO OK. Sources will be downloaded.
)

ECHO.
ECHO.
ECHO OK. All properties defined. Your files are ready to be downloaded and installed.
ECHO The speed of this process depends on your internet and CPU speed and can take
ECHO time, so please be patient. Expect an average of 2-3 minutes per selected version.

:: wait for keyboard confirmation by the user before
:: starting the download process.
PAUSE

FOR /L %%n IN (0, 1, %VERSION_MAX_INDEX%) DO (
   :: check if the version should be compiled
   IF !!VERSIONS[%%n].compile!! EQU 1 (

       :: Build up the command based on the given properties
       SET JAVA_COMMAND=JAVA -jar BuildTools.jar --rev %%VERSIONS[%%n].id%%
       IF !!COMPILE_CRAFTBUKKIT!! EQU 1 (
            SET JAVA_COMMAND=!!JAVA_COMMAND!! --compile craftbukkit
       )
       IF !!COMPILE_CHANGES_ONLY!! EQU 1 (
            SET JAVA_COMMAND=!!JAVA_COMMAND!! --compile-if-changed
       )
       IF !!COMPILE_SOURCES!! EQU 1 (
            SET JAVA_COMMAND=!!JAVA_COMMAND!! --generate-source
       )
       IF !!COMPILE_DOCS!! EQU 1 (
            SET JAVA_COMMAND=!!JAVA_COMMAND!! --generate-docs
       )

       CALL ECHO.
       CALL ECHO.
       CALL ECHO Installing version %%VERSIONS[%%n].id%%
       CALL MKDIR %%VERSIONS[%%n].id%%
       CALL COPY %%LOCAL_FILE_NAME%% %%VERSIONS[%%n].id%%\%%LOCAL_FILE_NAME%%
       CALL CD %%VERSIONS[%%n].id%%
       CALL ECHO Executing BuildTools with command !!JAVA_COMMAND!!
       CALL JAVA -jar BuildTools.jar --rev %%VERSIONS[%%n].id%%
       CALL CD ..
   ) ELSE (
       CALL ECHO Skipping version %%VERSIONS[%%n].id%%...
   )
)

:: Disable delayed variable expansion again to avoid
:: unexpected behavior in the rest of the script.
ENDLOCAL

GOTO INSTALLATION_FINISHED

:: Downloads the latest BuildTools files to a subfolder or
:: searches for an existing file in that folder if no internet
:: connection is available.
:DOWNLOAD_LATEST_BUILD_TOOLS

:: Perform a onetime ping to google to check if the user currently has internet
:: access. If true, the latest BuildTools are downloaded from SpigotMC, if not
:: the script checks for an existing BuildTools file.
PING -n 1 www.google.com | FINDSTR TTL && GOTO INTERNET_CONNECTION_AVAILABLE

ECHO You seem to be disconnected from the Internet. Searching for existing BuildTools.jar...
IF NOT EXIST %LOCAL_FOLDER_NAME%\ (
    mkdir %LOCAL_FOLDER_NAME%
)
cd %LOCAL_FOLDER_NAME%

IF NOT EXIST %LOCAL_FILE_NAME% (
    ECHO Could not find a BuildTools.jar file.
    ECHO Please ensure your file is named %LOCAL_FILE_NAME% and is located in a folder called %LOCAL_FOLDER_NAME%\.
    GOTO END_APPLICATION
)

ECHO Existing %LOCAL_FILE_NAME% file found!
ECHO The compilation will be performed in offline-mode using this file.
ECHO But please note that it is recommended to connect to the Internet and
ECHO run this script again to be able to have the latest dependencies installed.
GOTO INSTALL_MODE_SELECTION

:: The PC is currently connected to the internet and the
:: latest BuildTools can be downloaded from the spigot repository.
:INTERNET_CONNECTION_AVAILABLE

IF NOT EXIST %LOCAL_FOLDER_NAME%\ (
    ECHO No sub-directory found. Creating %LOCAL_FOLDER_NAME%\ to save build output!
    MKDIR %LOCAL_FOLDER_NAME%
)
cd %LOCAL_FOLDER_NAME%\
ECHO.
ECHO Downloading latest BuildTools.jar from Jenkins repository...
curl -z BuildTools.jar -o BuildTools.jar %LATEST_BUILD_TOOLS_DOWNLOAD%
ECHO.
ECHO Successfully downloaded latest BuildTools.jar!
GOTO INSTALL_MODE_SELECTION

:: Called when any installation mode has finished downloading and
:: compiling all versions.
:INSTALLATION_FINISHED
ECHO.
ECHO.
ECHO.
ECHO The installation has finished! All selected versions have been installed to your local
ECHO maven repository. You can also find the files in the %LOCAL_FOLDER_NAME% folder.
GOTO END_APPLICATION

:END_APPLICATION

PAUSE
