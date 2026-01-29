@echo off
if "%~1"=="" (
    uv --directory "%~dp0." run dart-lsp-watcher . --capabilities
) else (
    uv --directory "%~dp0." run dart-lsp-watcher %* --capabilities
)
