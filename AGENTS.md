# AGENTS.md

Unity 6.3 / URP 17 프로젝트. 모든 코딩 에이전트의 공통 지침(스킬 정본은 `.agents/skills/`).
`CLAUDE.md`는 이 파일을 `@AGENTS.md`로 임포트하므로, 지침 변경은 항상 **여기**에 한다.

## 편집 금지 (Unity가 관리)

- `*.meta` — Unity가 GUID와 함께 자동 생성.
- `*.unity`·`*.prefab`·`*.asset`·`*.mat` 등 YAML 자산 — 에디터로만 편집, 텍스트 직접 편집 금지.
- `Packages/packages-lock.json`, `ProjectSettings/` — Unity·Package Manager가 관리.

## 코드

- 위치 `Assets/Scripts/`. 기능 단위 폴더마다 `.asmdef`(이름=폴더 경로, 에디터 전용은 Editor asmdef로 분리).
- 스타일은 `.editorconfig`(C# 4-space, max 120). 자동 포매터 훅은 쓰지 않는다(턴마다 포맷하면 에이전트가 파일을 다시 읽어야 함). **커밋 전에 `npm run format:changed`**(변경·신규 파일만 CSharpier·Prettier)를 실행한다. 포매팅 외 목적의 훅은 사용할 수 있다.
- 포매터 버전은 고정(`package.json`, `.config/dotnet-tools.json`)한다. 최신으로 올릴 때는 `npm run update:formatters` 후 커밋한다.
- 입력은 Input System(레거시 Input Manager 금지), 렌더는 URP.
- 비동기 구현은 별도 지시가 없어도 UniTask를 사용한다.
- R3와 VContainer는 사용자가 명시적으로 요청한 경우에만 사용한다.
- 템플릿 기본 설치 패키지: UniTask·R3·VContainer·NuGetForUnity. 프로젝트에서 쓰지 않으면 제거한다(아래 「유니티 에디터 사용 규칙」의 패키지 명령).

## 편집 경로

- Unity 프로젝트 콘텐츠 중 직접 수정하는 파일은 C#·셰이더 등 소스 코드 텍스트 파일로 한정한다.
- 씬·에셋·프리팹 등 Unity 직렬화 자산은 텍스트로 직접 수정하지 않고 에디터를 통해(`unity` CLI 또는 에디터 스크립트) 수정한다.

## 저장소 위생

- 용도가 없는 빈 폴더는 삭제한다. 저장소 구조상 빈 폴더를 유지해야 할 때만 `.gitkeep`을 추가한다.

## 컴파일·테스트

- Unity 에디터가 컴파일한다. `dotnet build`/`dotnet test`로 검증하지 않는다(.csproj는 IDE용이며 Unity가 재생성).
- 코드 변경 후 열린 에디터에서 `unity` CLI로 에러를 확인한다(아래 「유니티 에디터 사용 규칙」). 테스트는 Unity Test Framework.

## 유니티 에디터 사용 규칙

- 에디터는 **원본 체크아웃에 열린 하나만** 쓴다. worktree를 만들지 않고 원본 체크아웃에서 작업한다.
- 에디터가 필요한 작업(씬·프리팹·에셋 변경, 플레이 모드, 테스트, 빌드)은 **한 번에 한 에이전트**만 한다. 문서 편집·코드 읽기처럼 에디터가 필요 없는 작업은 동시에 해도 된다.
- `unity` CLI(`com.unity.pipeline`)에는 항상 `--project-path`를 붙인다.
- 패키지 추가·제거는 `unity command package add|remove --project-path . --name <패키지> --confirm true --wait true`로 한다(`packages-lock.json`도 에디터가 갱신). 에디터가 닫혀 있을 때만 `Packages/manifest.json`을 직접 고친다.
- 검증 — 실행 중인 에디터를 재사용한다(`unity status`로 연결 확인). `unity build`는 배치 모드로 에디터를 새로 띄우므로 에디터가 열려 있을 때는 쓰지 않는다:
    - 컴파일: `unity recompile --project-path .` → `unity command console get --project-path . --level error`
    - 테스트: `unity command test run --project-path . --mode editor`

## 패키지 소스

- `Library/PackageCache/`에 URP·InputSystem 등 실제 소스가 있으나 `.gitignore`라 Glob/Grep에 안 잡힌다. 참조 시: `rg --no-ignore -t cs "<패턴>" Library/PackageCache/<패키지>@*/`
