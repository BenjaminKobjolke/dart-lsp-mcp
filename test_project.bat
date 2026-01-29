@echo off
uv --directory "%~dp0." run dart-lsp-watcher "%~dp0test_project" --timeout 3
