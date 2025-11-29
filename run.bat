@echo off
REM Try to find love.exe in common locations
set "LOVE_PATH=C:\Program Files\LOVE\love.exe"
if exist "%LOVE_PATH%" goto run

set "LOVE_PATH=C:\Program Files (x86)\LOVE\love.exe"
if exist "%LOVE_PATH%" goto run

REM Check if love is in PATH
where love >nul 2>nul
if %errorlevel% equ 0 (
    set "LOVE_PATH=love"
    goto run
)

echo [ERROR] Love2D (love.exe) not found.
echo Please install Love2D or edit this file to point to your love.exe.
echo You can download it from https://love2d.org/
pause
exit /b

:run
echo Launching with: "%LOVE_PATH%"
"%LOVE_PATH%" .
