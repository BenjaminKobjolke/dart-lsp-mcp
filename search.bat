@echo off
if "%~1"=="" (
    echo Usage: search.bat QUERY [FOLDER]
    echo Example: search.bat MyClass
    exit /b 1
)
set QUERY=%~1
set FOLDER=%~2
if "%FOLDER%"=="" set FOLDER=.
uv --directory "%~dp0." run dart-lsp-watcher %FOLDER% --search %QUERY%
