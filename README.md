# claude-status

Claude Code status bar. 모델, 컨텍스트 사용량, 사용량(usage) 등 20개 요소를 골라서 표시합니다.
구독(Pro/Max/Team)과 Enterprise 플랜을 자동으로 구분해 플랜마다 다른 요소 세트를 씁니다.

```
구독        workspace/claude-status  main 󰚩 sonnet 4.6 30% 5h:12% 7d:9% 5h↻3h51m 7d↻3d9h
Enterprise  workspace/claude-status  main 󰚩 sonnet 4.6 30% $1.23 $449/$1000 44.9%
```

## 플랜별 동작

| | 구독 (Pro/Max/Team) | Enterprise |
|---|---|---|
| `usage` | 5시간·7일 사용률 `5h:12% 7d:9%` | 월 크레딧 사용량 `$449/$1000 44.9%` |
| 전용 요소 | `reset` — 5h/7d 리셋까지 남은 시간 | `credits` — 이번 달 남은 크레딧 |
| 기본 요소 | dir git model context usage **reset** | dir git model context usage **cost** |
| 데이터 | Claude Code가 넘겨주는 `rate_limits` (실시간, API 호출 없음) | OAuth usage API (3분 캐시, 실패 시 만료 캐시 fallback) |

요소 세트는 플랜마다 따로 저장되므로, 계정을 바꾸면 그 플랜의 세트로 자동 전환됩니다.

플랜 감지 순서:

1. 설정의 `plan`이 `subscription`/`enterprise`면 그대로 사용 (`--set-plan`)
2. usage 캐시의 `subscription_type` (API를 조회할 때 자격증명의 `subscriptionType`을 같이 저장)
3. Claude Code 입력에 5h/7d `rate_limits`가 있으면 구독
4. `extra_usage.is_enabled`이고 5h/7d가 없으면 Enterprise
5. 그 밖에는 구독

## 요소

| 요소 | 설명 | 예시 | 구독 | Ent |
|------|------|------|:---:|:---:|
| `dir` | 디렉토리 (마지막 2단계) | `workspace/claude-status` | ✔ | ✔ |
| `git` | git 브랜치 | ` main` | ✔ | ✔ |
| `git_status` | git 변경(`*`)·ahead/behind | `*↑1↓2` | | |
| `pr` | 열린 PR + 리뷰 상태 (클릭 시 이동) | `PR#53 ✓` | | |
| `model` | 모델 (NerdFont 아이콘) | `󰚩 sonnet 4.6` | ✔ | ✔ |
| `effort` | effort 레벨 | `● high` | | |
| `thinking` | extended thinking 켜짐 | `✻ think` | | |
| `output_style` | 출력 스타일 (기본값 외에만) | `✎ explanatory` | | |
| `version` | Claude Code 버전 | `v2.1.309` | | |
| `context` | 컨텍스트 사용률 | `30%` (한 자리면 ` 5%`) | ✔ | ✔ |
| `context_tokens` | 컨텍스트 토큰 사용/전체 | `60k/200k` | | |
| `context_bar` | 컨텍스트 바 (40%↑ 노랑, 60%↑ 빨강) | `███░░░░░░░` | | |
| `cache` | 프롬프트 캐시 히트율·TTL, 식으면 `cache cold` | `cache 73% 1h` | | |
| `cost` | 세션 누적 비용 | `$1.23` | | ✔ |
| `lines` | 세션 변경 라인 | `+156 -23` | | |
| `duration` | 세션 경과 시간 | `◷ 1h12m` | | |
| `plan` | 플랜 이름 | `Max` / `Enterprise` | | |
| `usage` | 사용량 (위 표 참고) | `5h:12% 7d:9%` | ✔ | ✔ |
| `reset` | 5h/7d 리셋까지 남은 시간 (구독 전용) | `5h↻3h51m 7d↻3d9h` | ✔ | - |
| `credits` | 이번 달 남은 크레딧 (Enterprise 전용) | `rem $551` | - | |

요소는 위 표의 순서대로 그립니다. 값이 없는 요소(PR이 없을 때의 `pr` 등)는 자리를 차지하지 않습니다.
이와 별도로 `progress`(터미널 진행바, OSC 9;4)도 켜고 끌 수 있습니다.

## 설정

```bash
claude-status --config
```

인터랙티브 설정 화면이 열립니다. `↑↓` 이동, `Space` 켜기/끄기, `←→` 플랜 탭 전환, `d` 기본값, `p` 플랜 감지 고정/자동, `Enter` 저장, `q` 취소. 아래쪽에 예시 데이터로 그린 미리보기가 나옵니다.

명령으로 바꿀 수도 있습니다. `--plan`을 빼면 지금 감지된 플랜에 적용합니다.

```bash
claude-status --list                                    # 요소 목록과 플랜별 켜짐 상태
claude-status --enable cost,lines --plan subscription   # 켜기
claude-status --disable reset                           # 끄기
claude-status --disable progress                        # 터미널 진행바 끄기
claude-status --set-plan enterprise                     # 플랜 감지 고정 (auto로 되돌리기)
claude-status --preview                                 # 플랜별 미리보기
```

설정은 `~/.claude/claude-status.json`에 저장됩니다. 파일이 없거나 플랜 항목이 없으면 기본 요소를 씁니다.

```json
{
  "plan": "auto",
  "progress": true,
  "elements": {
    "subscription": ["dir", "git", "model", "context", "usage", "reset"],
    "enterprise": ["dir", "git", "model", "context", "cost", "usage"]
  }
}
```

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

- Python 3 (표준 라이브러리만 사용)
- NerdFont 적용 터미널

## 파일

- **`claude-status`** — Claude Code 세션 JSON을 읽어 켜진 요소를 ANSI 색상으로 출력하는 Python 스크립트. 설정 화면과 CLI 포함
- **`claude-usage`** — Anthropic OAuth API(`/api/oauth/usage`) 조회·캐시·플랜 감지. 단독으로 실행하면 사용량 한 줄을 출력하고, `claude-status`가 같은 폴더에서 모듈로 불러 씁니다
- **`install.sh`** — 파일을 올바른 위치에 복사하고 settings.json을 업데이트하는 설치 스크립트

## 수정 후 배포

```bash
./install.sh
```
