# How to Integrate Dart LSP MCP into Your Dart/Flutter Project

This guide explains how to set up the Dart LSP MCP server for use with Claude Code in your Dart/Flutter projects.

## Prerequisites

- **Python 3.10+**
- **Dart SDK** installed and in PATH:
  ```bash
  dart --version
  ```
- **uv** package manager (Python)
- **Claude Code** CLI installed

## Step 1: Register the MCP Server with Claude Code

Run one of these commands (only needed once, applies globally):

### Option A: Direct registration (recommended)

```bash
claude mcp add --transport stdio dart-lsp -- uv --directory D:\GIT\BenjaminKobjolke\dart-lsp-mcp run python -m dart_lsp_watcher.mcp_server
```

### Option B: Using the .mcp.json file

The project includes a `.mcp.json` file that can be used with Claude Code's plugin system.

## Step 2: Verify Installation

1. Start Claude Code in your project
2. Run `/mcp` to check the server is connected
3. Test with: "Use dart-lsp to check diagnostics for this project"

## Step 3: Update Your Project's CLAUDE.md

Add the following section to your project's `CLAUDE.md` file to instruct Claude to prefer LSP tools over file search:

```markdown
## LSP Server - MANDATORY

**CRITICAL: ALWAYS use LSP Server FIRST for code navigation tasks.**
**CRITICAL: ALWAYS use LSP Server FIRST for code Search.**
**CRITICAL: ALWAYS use LSP Server understand the code dependency.**

- YOU MUST Proactively suggest fixing LSP diagnostic issues as soon as they appear
- YOU MUST Leave code in a working state after every change
- CRITICAL: ALWAYS publish new LSP diagnostic errors as soon as they appear and suggest fixing them
- CRITICAL: ALWAYS display fixed LSP diagnostic errors in the output after every code change
- CRITICAL: LSP diagnostic errors MUST be displayed as LSP diagnostic in the output after every code change

Before using Search/Glob/Grep/Read to find implementations, references, or definitions:
1. **FIRST try using LSP Server**
2. Only fall back to Search/Glob/Grep if LSP doesn't provide results

### Available MCP Tools (dart-lsp)

| Tool | Purpose |
|------|---------|
| `mcp__dart-lsp__find_references` | Find all references to a symbol at position |
| `mcp__dart-lsp__go_to_definition` | Navigate to symbol definition |
| `mcp__dart-lsp__get_hover` | Get type info and documentation for symbol |
| `mcp__dart-lsp__search_symbols` | Search symbols across entire workspace by name |
| `mcp__dart-lsp__get_document_symbols` | Get all symbols (classes, functions, variables) in a file |
| `mcp__dart-lsp__get_diagnostics` | Get Dart diagnostics/errors for project or file |
| `mcp__dart-lsp__reindex` | Re-scan workspace to detect new/removed Dart files |

### Tool Parameters

**All tools require:**
- `project_path`: Absolute path to your project root (e.g., `D:\GIT\my-flutter-app`)

**Position-based tools** (find_references, go_to_definition, get_hover):
- `file_path`: Absolute path to Dart file
- `line`: 0-indexed line number
- `column`: 0-indexed column number (position cursor on the symbol name)

**Search tools:**
- `search_symbols`: requires `query` (partial name match)
- `get_document_symbols`: requires `file_path`
- `get_diagnostics`: optional `file_path` (omit for all files), optional `min_severity`

### Usage Examples

```
# Find all references to a method (position on method name)
mcp__dart-lsp__find_references(project_path, file_path, line=179, column=22)

# Jump to definition from a call site
mcp__dart-lsp__go_to_definition(project_path, file_path, line=81, column=35)

# Get documentation for a symbol
mcp__dart-lsp__get_hover(project_path, file_path, line=179, column=22)

# Search for a symbol by name across codebase
mcp__dart-lsp__search_symbols(project_path, query="MyClassName")

# Get all symbols in a file
mcp__dart-lsp__get_document_symbols(project_path, file_path)

# Check for Dart errors in project
mcp__dart-lsp__get_diagnostics(project_path)

# Re-scan workspace after creating/deleting Dart files
mcp__dart-lsp__reindex(project_path)
```

### When to Use LSP (ALWAYS for these tasks)

**MANDATORY - Use LSP Server for:**
- Finding interface implementations (e.g., "what classes implement this interface?")
- Finding class references (e.g., "where is this class used?")
- Finding method/property usages
- Navigating to definitions
- Getting type information and documentation
- Any code navigation task

**Only use Search/Glob/Grep/Read when:**
- LSP doesn't return results
- Searching for string patterns (not code symbols)
- Searching in non-Dart files
```

## Available Tools Reference

| Tool | Description | Parameters |
|------|-------------|------------|
| `get_diagnostics` | Get Dart errors/warnings for a project or specific file | `project_path`, `file_path?`, `min_severity?` |
| `find_references` | Find all references to a symbol at a position | `project_path`, `file_path`, `line`, `column` |
| `go_to_definition` | Go to symbol definition | `project_path`, `file_path`, `line`, `column` |
| `get_hover` | Get symbol documentation/type | `project_path`, `file_path`, `line`, `column` |
| `get_document_symbols` | List all symbols in file | `project_path`, `file_path` |
| `search_symbols` | Search workspace symbols | `project_path`, `query` |
| `get_capabilities` | Get LSP server capabilities | `project_path` |
| `reindex` | Re-scan workspace to detect new/removed Dart files | `project_path` |

## Configuration

Create a `dart_lsp.json` file in your project root to configure ignore patterns:

```json
{
  "ignore": [
    "build/**",
    ".dart_tool/**",
    "**/*.g.dart",
    "**/*.freezed.dart"
  ]
}
```

## Performance Notes

- **First call latency**: Initial call takes 5-10s for LSP startup + indexing
- **Subsequent calls**: Fast (LSP client stays running)
- **Memory**: Each project keeps an LSP process running
- **Single file check**: ~5s (only the target file is analyzed)

## Logging

The MCP server logs to `mcp.log` in the dart-lsp-mcp directory. View in real-time:

```powershell
# PowerShell
Get-Content -Path "D:\GIT\BenjaminKobjolke\dart-lsp-mcp\mcp.log" -Wait
```

## Troubleshooting

1. **MCP not showing in `/mcp`**: Re-run the registration command
2. **LSP errors**: Ensure Dart SDK is installed and `dart` is in PATH
3. **No results**: Check that `project_path` is correct and contains a `pubspec.yaml`
4. **Slow first response**: Normal - LSP is indexing the project (5-10s for large projects)
5. **"No issues found" for files with errors**: Increase timeout with `--timeout 10`
