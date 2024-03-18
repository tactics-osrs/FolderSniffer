@echo off
REM Script Name: FolderSniffer
REM Date Written: March 12, 2024
REM Written By: Tactics
setlocal enabledelayedexpansion
title FolderSniffer

:: Start of the script
:start
cls

:: Prompt the user to enter the folder name
set "keyword="
set "number="
echo Please enter the folder name or 'help':
set /p keyword=

:: If the user enters 'help', display the help information
if /I "%keyword%"=="help" goto Help

:: If the user doesn't enter anything, display an error message and restart
if not defined keyword (
    echo Error: No folder name entered. Please enter a folder name.
    pause
    goto start
)

:: Search for folders with the name entered by the user
echo Searching for folders with the name "%keyword%"...
set i=0
for /d /r %%G in (*%keyword%*) do (
    set /a i+=1
    echo !i!. %%~nxG
    set "folder!i!=%%G"
)

:: If no folders are found, display an error message and restart
if !i! lss 1 (
    echo Error: No folders found with the name "%keyword%".
    pause
    goto start
)

:: Prompt the user to enter the number of the folder they want to open
:inputNumber
echo Please enter the number of the folder you want to open or type 'back' to go back:
set /p number=

:: If the user enters 'back', restart
if /I "%number%"=="back" goto start

:: Check if the input is a number
echo %number%|findstr /R "^[0-9]*$">nul
if %errorlevel%==1 (
    echo Error: Invalid input. Please enter a number or 'back'.
    pause
    goto inputNumber
)

:: If the user doesn't enter anything, display an error message and prompt again
if not defined number (
    echo Error: No number entered. Please enter a number or 'back'.
    pause
    goto inputNumber
)

:: If the user enters an invalid number, display an error message and prompt again
if not defined folder%number% (
    echo Error: Invalid number entered. Please enter a valid number or 'back'.
    pause
    goto inputNumber
)

:: Display the contents of the selected folder
set folder=!folder%number%!
echo Displaying the contents of the folder "!folder!":

set j=0
for %%G in ("!folder!\*") do (
    if not exist "%%~fG\*" (
        set /a j+=1
        echo !j!. %%~nxG
        set "file!j!=%%G"
    )
)

for /d %%G in ("!folder!\*") do (
    set /a j+=1
    echo !j!. %%~nxG
    set "file!j!=%%G"
)

echo.
echo Folder "!folder!" contents displayed above.

:: Prompt the user to enter the number of the file or subfolder they want to open
:inputFileNumber
echo Please enter the number of the file or subfolder you want to open or type 'back' to go back:
set /p number=

:: If the user enters 'back', restart
if /I "%number%"=="back" goto start

:: Check if the input is a number
echo %number%|findstr /R "^[0-9]*$">nul
if %errorlevel%==1 (
    echo Error: Invalid input. Please enter a number or 'back'.
    pause
    goto inputFileNumber
)

:: If the user doesn't enter anything, display an error message and prompt again
if not defined number (
    echo Error: No number entered. Please enter a number or 'back'.
    pause
    goto inputFileNumber
)

:: If the user enters an invalid number, display an error message and prompt again
if not defined file%number% (
    echo Error: Invalid number entered. Please enter a valid number or 'back'.
    pause
    goto inputFileNumber
)

:: Open the selected file or subfolder in File Explorer
set file=!file%number%!
start "" "!file!"
echo File or subfolder "!file!" opened in File Explorer.
pause
goto start

:: Display help information
:Help
echo.
echo This script searches for folders with a name that you provide.
echo.
echo If it finds folders with the name, the script then lists the folders and asks you to choose one by entering its corresponding number.
echo The selected folder's contents (only the files and subfolders in the selected folder, not in its subdirectories) are then displayed in the command prompt.
echo.
echo Then, you can enter the number corresponding to the file or subfolder you want to open.
echo The selected file or subfolder is then opened in File Explorer.
echo.
echo If you want to go back to the original input menu, you can type 'back' instead of a number.
echo.
echo Created by Tactics.
pause
goto start
