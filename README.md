# Dart LSP MCP

A Model Context Protocol (MCP) server that provides Dart language analysis capabilities to Claude Code. This tool uses the Dart language server to provide real-time diagnostics, code navigation, and symbol search for Dart projects.

## Features

- **Real-time Diagnostics**: Get errors, warnings, and hints from the Dart analyzer
- **Go to Definition**: Navigate to symbol definitions
- **Find References**: Find all usages of a symbol
- **Hover Information**: Get type information and documentation
- **Document Symbols**: List all symbols in a file
- **Workspace Symbol Search**: Search for symbols across the project

## Prerequisites

- Python 3.10+
- [uv](https://github.com/astral-sh/uv) (Python package manager)
- [Dart SDK](https://dart.dev/get-dart) (must be in PATH)

## Installation

1. Clone this repository
2. Install dependencies:

```bash
uv sync
```

## Usage

### As MCP Server (for Claude Code)

Add to your Claude Code MCP configuration:

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

### As CLI Tool

Watch a Dart project for diagnostics:

```bash
# Watch mode (continuous)
start.bat path/to/dart/project

# Check a single file
check.bat lib/main.dart path/to/dart/project

# Get server capabilities
capabilities.bat path/to/dart/project
```

### Available CLI Commands

| Command | Description |
|---------|-------------|
| `start.bat <folder>` | Watch folder for Dart diagnostics |
| `check.bat <file> [folder]` | Check a single file |
| `definition.bat <file> <line> <col> [folder]` | Go to definition |
| `references.bat <file> <line> <col> [folder]` | Find references |
| `hover.bat <file> <line> <col> [folder]` | Get hover info |
| `symbols.bat <file> [folder]` | List document symbols |
| `search.bat <query> [folder]` | Search workspace symbols |
| `capabilities.bat [folder]` | Show LSP capabilities |

## MCP Tools

When used as an MCP server, the following tools are available:

| Tool | Description |
|------|-------------|
| `get_diagnostics` | Get Dart diagnostics for a project or specific file |
| `find_references` | Find all references to a symbol at a position |
| `go_to_definition` | Navigate to symbol definition |
| `get_hover` | Get documentation and type info for a symbol |
| `get_document_symbols` | List all symbols in a file |
| `search_symbols` | Search for symbols across the workspace |
| `get_capabilities` | Get LSP server capabilities |

## Configuration

Create a `dart_lsp.json` file in your project root to configure ignore patterns:

```json
{
  "ignore": [
    "build/**",
    ".dart_tool/**",
    "**/*.g.dart"
  ]
}
```

## Development

Run tests:

```bash
tools\tests.bat
```

## License

MIT
