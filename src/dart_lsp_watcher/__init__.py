"""Dart LSP Watcher - Watch Dart files and display diagnostics in real-time."""

__version__ = "1.0.0"

from dart_lsp_watcher.api import Diagnostic, get_diagnostics
from dart_lsp_watcher.diagnostics import DiagnosticsDisplay

__all__ = ["Diagnostic", "get_diagnostics", "DiagnosticsDisplay"]
