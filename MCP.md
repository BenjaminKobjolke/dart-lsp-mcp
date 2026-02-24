# MCP Server Configuration

This document describes how to configure the Dart LSP MCP server for use with Claude Code.

## Installation

1. Ensure you have [uv](https://github.com/astral-sh/uv) installed
2. Ensure you have the [Dart SDK](https://dart.dev/get-dart) installed and in your PATH
3. Clone this repository to a local directory

## Configuration

Add the following to your Claude Code MCP configuration file:

### Windows

```json
{
  "mcpServers": {
    "dart-lsp": {
      "type": "stdio",
      "command": "uv",
      "args": ["--directory", "D:\\GIT\\BenjaminKobjolke\\dart-lsp-mcp", "run", "python", "-m", "dart_lsp_watcher.mcp_server"]
    }
  }
}
```

### macOS/Linux

```json
{
  "mcpServers": {
    "dart-lsp": {
      "type": "stdio",
      "command": "uv",
      "args": ["--directory", "/path/to/dart-lsp-mcp", "run", "python", "-m", "dart_lsp_watcher.mcp_server"]
    }
  }
}
```

### Direct CLI Registration

You can also register the MCP server directly using the Claude CLI:

**Windows:**
```bash
claude mcp add --scope project --transport stdio dart-lsp -- uv --directory D:\GIT\BenjaminKobjolke\dart-lsp-mcp run python -m dart_lsp_watcher.mcp_server
```

**macOS/Linux:**
```bash
claude mcp add --scope project --transport stdio dart-lsp -- uv --directory /path/to/dart-lsp-mcp run python -m dart_lsp_watcher.mcp_server
```

## Available Tools

## Usage Tips & Best Practices

### Line and Column Numbers
All tools use **0-indexed** line and column numbers:
- Line 1 in your editor = line 0 for the tool
- Column 1 in your editor = column 0 for the tool

### Finding References Effectively
The `find_references` tool works best when called from a **usage site** rather than the definition:

**Less reliable** (from definition file):
```
find_references(
  project_path: "/path/to/project",
  file_path: "/path/to/project/lib/utils/my_class.dart",  # definition file
  line: 1,  # class MyClass definition
  column: 6
)
# May return "No references found"
```

**More reliable** (from usage file):
```
find_references(
  project_path: "/path/to/project",
  file_path: "/path/to/project/lib/services/service.dart",  # file that USES MyClass
  line: 10,  # where MyClass is used
  column: 4
)
# Returns all references across the workspace
```

### Workflow for Finding All References
1. Use `search_symbols` to find where a symbol is defined
2. Use `get_hover` to verify you have the correct position
3. Find a file that imports/uses the symbol
4. Call `find_references` from that usage site

### Prefer LSP Over Text Search
For Dart projects, prefer these LSP tools over Grep/text search because:
- They understand Dart semantics (won't match strings or comments)
- They find usages through method calls, inheritance, etc.
- They provide exact positions with column numbers

### get_diagnostics

Get Dart diagnostics for a project or specific file.

**Parameters:**
- `project_path` (required): Absolute path to the Dart project root
- `file_path` (optional): Specific file to check (returns all if omitted)
- `min_severity` (optional): Minimum severity level (error, warning, info, hint)
- `ignore_unused_underscore` (optional): Filter out unused _xxx variable hints (default: true)

### find_references

Find all references to a symbol at a specific position.

**Parameters:**
- `project_path` (required): Absolute path to the Dart project root
- `file_path` (required): Absolute path to the Dart file
- `line` (required): 0-indexed line number
- `column` (required): 0-indexed column number

**Tip:** For best results, call from a file that *uses* the symbol rather than the file where it's defined. See "Usage Tips & Best Practices" above.

### go_to_definition

Go to definition of symbol at position.

**Parameters:**
- `project_path` (required): Absolute path to Dart project root
- `file_path` (required): Absolute path to Dart file
- `line` (required): 0-indexed line number
- `column` (required): 0-indexed column number

### get_hover

Get hover information (documentation, type) for symbol.

**Parameters:**
- `project_path` (required): Absolute path to Dart project root
- `file_path` (required): Absolute path to Dart file
- `line` (required): 0-indexed line number
- `column` (required): 0-indexed column number

### get_document_symbols

Get all symbols (classes, functions, variables) in a Dart file.

**Parameters:**
- `project_path` (required): Absolute path to Dart project root
- `file_path` (required): Absolute path to Dart file

### search_symbols

Search for symbols across the workspace.

**Parameters:**
- `project_path` (required): Absolute path to Dart project root
- `query` (required): Search query (partial name match)

### get_capabilities

Get LSP server capabilities for a project.

**Parameters:**
- `project_path` (required): Absolute path to the Dart project root

## Logging

The MCP server writes logs to `mcp.log` in the project root directory. This file contains detailed information about tool calls and any errors that occur.

## Troubleshooting

### "dart not found" error

Ensure the Dart SDK is installed and `dart` is available in your system PATH:

```bash
dart --version
```

### LSP connection fails

1. Check that the Dart SDK is properly installed
2. Verify the project path exists and contains a `pubspec.yaml` file
3. Check `mcp.log` for detailed error messages

### No diagnostics returned

1. Ensure the project has a valid `pubspec.yaml`
2. Run `dart pub get` to resolve dependencies
3. Wait a few seconds for the analyzer to process files
