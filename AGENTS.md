# AGENTS.md

Unity 6.3 / URP 17 프로젝트. Codex·Claude Code 등 모든 에이전트의 공통 지침.

## 편집 금지 (Unity가 관리)

- `*.meta` — Unity가 GUID와 함께 자동 생성.
- `*.unity`·`*.prefab`·`*.asset`·`*.mat` 등 YAML 자산 — 에디터로만 편집, 텍스트 직접 편집 금지.
- `Packages/packages-lock.json`, `ProjectSettings/` — Unity·Package Manager가 관리.

## 코드

- 위치 `Assets/Scripts/`. 기능 단위 폴더마다 `.asmdef`(이름=폴더 경로, 에디터 전용은 Editor asmdef로 분리).
- 스타일은 `.editorconfig`(C# 4-space, max 120). 자동 포매터 훅은 사용하지 않고, 커밋 전에 `dotnet csharpier format Assets`와 `npm run format`을 직접 실행한다. 포매팅 외 목적의 훅은 사용할 수 있다.
- 입력은 Input System(레거시 Input Manager 금지), 렌더는 URP.
- 비동기 구현은 별도 지시가 없어도 UniTask를 사용한다.
- R3와 VContainer는 사용자가 명시적으로 요청한 경우에만 사용한다.

## 편집 경로

- Unity 프로젝트 콘텐츠 중 직접 수정하는 파일은 C#·셰이더 등 소스 코드 텍스트 파일로 한정한다.
- 씬·에셋·프리팹 등 Unity 직렬화 자산은 텍스트로 직접 수정하지 않고 CoPlay MCP로 수정한다.

## 저장소 위생

- 용도가 없는 빈 폴더는 삭제한다. 저장소 구조상 빈 폴더를 유지해야 할 때만 `.gitkeep`을 추가한다.

## 컴파일·테스트

- Unity 에디터가 컴파일한다. `dotnet build`/`dotnet test`로 검증하지 않는다(.csproj는 IDE용이며 Unity가 재생성).
- 코드 변경 후 CoPlay MCP `read_console`로 에러를 확인한다. 테스트는 Unity Test Framework.

## 패키지 소스

- `Library/PackageCache/`에 URP·InputSystem 등 실제 소스가 있으나 `.gitignore`라 Glob/Grep에 안 잡힌다. 참조 시: `rg --no-ignore -t cs "<패턴>" Library/PackageCache/<패키지>@*/`
