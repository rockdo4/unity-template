# Shared helpers for Claude Code / Cursor format hooks (bash).

_hook_dir() {
  cd "$(dirname "${BASH_SOURCE[1]}")" && pwd
}

_is_repo_root() {
  local dir="$1"
  [[ -f "$dir/package.json" ]] ||
    [[ -f "$dir/dotnet-tools.json" ]] ||
    [[ -f "$dir/.config/dotnet-tools.json" ]]
}

get_repo_root() {
  local dir
  dir="$(_hook_dir)"
  while [[ -n "$dir" ]]; do
    if _is_repo_root "$dir"; then
      printf '%s\n' "$dir"
      return 0
    fi
    local parent
    parent="$(dirname "$dir")"
    [[ "$parent" == "$dir" ]] && break
    dir="$parent"
  done
  echo "Could not find repo root from $(_hook_dir)" >&2
  return 1
}

# Claude Code: tool_input.file_path / Cursor: file_path
extract_file_path() {
  local payload="$1"
  if [[ -z "$payload" ]]; then
    return 0
  fi
  if command -v node >/dev/null 2>&1; then
    printf '%s' "$payload" | node -e "
      const fs = require('fs');
      try {
        const d = JSON.parse(fs.readFileSync(0, 'utf8'));
        process.stdout.write(d.file_path || (d.tool_input && d.tool_input.file_path) || '');
      } catch {}
    "
    return 0
  fi
  if command -v python3 >/dev/null 2>&1; then
    printf '%s' "$payload" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    print(d.get('file_path') or (d.get('tool_input') or {}).get('file_path') or '', end='')
except json.JSONDecodeError:
    pass
"
    return 0
  fi
  echo "format hook: need node or python3 to parse hook JSON" >&2
  return 1
}

is_absolute_path() {
  [[ "$1" == /* ]] || [[ "$1" =~ ^[A-Za-z]:[/\\] ]]
}

resolve_file_path() {
  local file_path="$1"
  local repo_root="$2"
  if is_absolute_path "$file_path"; then
    printf '%s\n' "$file_path"
  else
    printf '%s\n' "$repo_root/$file_path"
  fi
}
