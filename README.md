# claude-status

Claude Code status bar. 모델, 컨텍스트 사용량, 월간 usage를 표시합니다.

```
workspace/claude-status  main 󰚩 sonnet 4.6  30%  $449/$1000 44.9%
```

| 항목 | 설명 |
|------|------|
| 디렉토리 | 현재 경로 (마지막 2단계) |
| git | 브랜치 아이콘 + 브랜치명 |
| 모델 | 현재 사용 중인 Claude 모델 (NerdFont 아이콘 포함) |
| 컨텍스트 | 컨텍스트 윈도우 사용률 (%) |
| 월간 usage | Anthropic API를 조회해 표시 (3분 캐시, API 실패 시 만료 캐시 fallback) |

## 설치

```bash
./install.sh
```

| 파일 | 설치 경로 |
|------|----------|
| `claude-status` | `~/.local/bin/claude-status` |
| `claude-usage` | `~/.local/bin/claude-usage` |

`~/.claude/settings.json`의 `statusLine`도 자동으로 설정됩니다.

## 요구사항

- `jq`
- Python 3 (표준 라이브러리만 사용)
- NerdFont 적용 터미널

## 파일

- **`claude-status`** — Claude Code 세션 JSON을 파싱해 ANSI 색상으로 status bar를 출력하는 bash 스크립트
- **`claude-usage`** — Anthropic OAuth API(`/api/oauth/usage`)를 조회해 월간 usage를 출력하는 Python 스크립트
- **`install.sh`** — 파일을 올바른 위치에 복사하고 settings.json을 업데이트하는 설치 스크립트

## 수정 후 배포

```bash
./install.sh
```
