@echo off
if "%~1"=="" (
    echo Usage: definition.bat FILE LINE COL [FOLDER]
    echo Example: definition.bat lib/main.dart 10 15
    exit /b 1
)
set FILE=%~1
set LINE=%~2
set COL=%~3
set FOLDER=%~4
if "%FOLDER%"=="" set FOLDER=.
uv --directory "%~dp0." run dart-lsp-watcher %FOLDER% --definition %FILE% %LINE% %COL%
