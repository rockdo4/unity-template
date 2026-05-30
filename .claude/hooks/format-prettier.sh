#!/usr/bin/env bash
set +e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

payload="$(cat)"
[[ -z "$payload" ]] && exit 0

file_path="$(extract_file_path "$payload")"
[[ -z "$file_path" ]] && exit 0

# VS Code Prettier 대상과 동일한 확장자
if ! [[ "$file_path" =~ \.(jsonc?|md|markdown|ya?ml|m?jsx?|cjs|mjs|tsx?|html|css|scss|less)$ ]]; then
  exit 0
fi

# 벤더 에셋 (TextMesh Pro 등)
if [[ "$file_path" =~ (^|[/\\])Assets[/\\]TextMesh\ Pro[/\\] ]]; then
  exit 0
fi

repo_root="$(get_repo_root)" || exit 0
file_path="$(resolve_file_path "$file_path" "$repo_root")"
[[ -f "$file_path" ]] || exit 0

ignore_file="$repo_root/.prettierignore"
[[ -f "$ignore_file" ]] || exit 0

node_modules="$repo_root/node_modules"
if [[ ! -d "$node_modules" ]]; then
  (
    cd "$repo_root" || exit 0
    npm ci --ignore-scripts >/dev/null 2>&1
  )
fi
[[ -d "$node_modules" ]] || exit 0

(
  cd "$repo_root" || exit 0
  npm exec -- prettier --write --ignore-path "$ignore_file" -- "$file_path" >/dev/null 2>&1
)
exit 0
