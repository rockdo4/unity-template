# Unity Template

Unity 6.3 / URP 17 기반 프로젝트 템플릿. GitHub **템플릿 저장소(Template repository)** 로 새 프로젝트를 만들 수 있습니다.

## 새 프로젝트 시작

1. GitHub에서 **Use this template** → 새 저장소 생성 (또는 `git clone` 후 `origin` 변경).
2. Unity Hub로 프로젝트 열기 → **Edit > Project Settings > Player**에서 `companyName`, `productName` 변경.
3. 이 README를 프로젝트 소개로 교체.
4. 최초 1회 로컬 개발 환경 초기화(에이전트의 `/setup` 스킬로도 실행 가능):

```bash
bash .agents/skills/setup/setup.sh
```

5. 쓰지 않는 기본 패키지(UniTask·R3·VContainer·NuGetForUnity)는 제거한다. 에디터를 연 상태에서:

```bash
unity command package remove --project-path . --name <패키지> --confirm true --wait true
```

6. 에이전트는 `unity` CLI(`com.unity.pipeline`)로 열린 에디터를 다룬다. 연결 확인: `unity status`.
7. Windows에서는 `.claude/skills` 심볼릭 링크를 위해 개발자 모드를 켜고 `git config core.symlinks true` 후 체크아웃한다.

대용량 바이너리가 많아지면, 새 저장소에서 [Git LFS](https://git-lfs.github.com/)를 별도로 도입하면 됩니다.
