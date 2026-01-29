@echo off
if "%~1"=="" (
    echo Usage: symbols.bat FILE [FOLDER]
    echo Example: symbols.bat lib/main.dart
    exit /b 1
)
set FILE=%~1
set FOLDER=%~2
if "%FOLDER%"=="" set FOLDER=.
uv --directory "%~dp0." run dart-lsp-watcher %FOLDER% --symbols %FILE%
