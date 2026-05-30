#!/usr/bin/env bash
set +e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

payload="$(cat)"
[[ -z "$payload" ]] && exit 0

file_path="$(extract_file_path "$payload")"
[[ -z "$file_path" ]] && exit 0
[[ "$file_path" != *.cs ]] && exit 0

# Assets/ 하위만 (상대·절대, Windows / *nix)
if ! [[ "$file_path" =~ (^|[/\\])Assets[/\\] ]]; then
  exit 0
fi

# 벤더 에셋 (TextMesh Pro 등)
if [[ "$file_path" =~ (^|[/\\])Assets[/\\]TextMesh\ Pro[/\\] ]]; then
  exit 0
fi

repo_root="$(get_repo_root)" || exit 0
file_path="$(resolve_file_path "$file_path" "$repo_root")"
[[ -f "$file_path" ]] || exit 0

(
  cd "$repo_root" || exit 0
  dotnet csharpier format -- "$file_path" >/dev/null 2>&1
)
exit 0
