# AI Hooks Demo — Nuxt 4

A reference project that demonstrates how **deterministic AI guardrails (hooks)** enforce security, formatting, and context injection regardless of what an AI coding agent tries to do.

---

## Quick Start

```bash
npm install
npm run dev
```

---

## Project Structure

```
.
├── app/                         # Nuxt 4 app directory
│   ├── app.vue
│   ├── components/
│   │   ├── UserLogin.vue        # ⚠️  Intentionally insecure (hook demo target)
│   │   └── SprintData.vue
│   ├── composables/
│   │   └── useSprintData.ts
│   └── pages/
│       └── index.vue
├── server/
│   └── api/
│       └── data.ts              # Sprint data endpoint (MCP-style demo)
├── .github/
│   └── hooks/
│       ├── format.json          # PostToolUse → Prettier on every AI edit
│       └── security-guard.json  # PreToolUse → blocks DANGEROUS_PLAINTEXT_PASSWORD
├── .claude/
│   └── settings.json            # UserPromptSubmit + Stop hooks
├── scripts/
│   └── security-check.sh        # Bash script called by security-guard hook
└── SESSIONS.md                  # Task context injected by Claude's UserPromptSubmit hook
```

---

## Hook Overview

| Hook | Agent | Event | Effect |
|---|---|---|---|
| `format.json` | GitHub Copilot | `PostToolUse` | Runs `npx prettier --write` on any file the AI just modified |
| `security-guard.json` | GitHub Copilot | `PreToolUse` | Calls `security-check.sh`; **denies** writes containing `DANGEROUS_PLAINTEXT_PASSWORD` |
| `settings.json` (UserPromptSubmit) | Claude Code | `UserPromptSubmit` | Appends `SESSIONS.md` when user asks *"What should I do next?"* |
| `settings.json` (Stop) | Claude Code | `Stop` | Desktop notification (or console log) when Claude finishes a long task |

---

## Demo Scenarios

### 1 — Security Guard (PreToolUse)
Ask the AI to add a hardcoded credential to `UserLogin.vue`:
> *"Add a fallback password `DANGEROUS_PLAINTEXT_PASSWORD` for testing."*

The `security-guard` hook fires **before** the file is written. `security-check.sh` reads the proposed content from stdin and returns `{"action":"deny"}`, blocking the operation entirely.

### 2 — Auto-Format (PostToolUse)
Ask the AI to make any edit without caring about whitespace. After it writes the file the `format` hook automatically runs Prettier, so committed code is always consistently styled.

### 3 — Context Injection (UserPromptSubmit)
In Claude Code, type:
> *"What should I do next?"*

The `UserPromptSubmit` hook appends the three tasks from `SESSIONS.md` to your prompt. Claude responds with a prioritised plan without you having to paste anything manually.

### 4 — Completion Notification (Stop)
Start a long refactor. When Claude signals it has finished, the `Stop` hook fires a desktop notification (Windows MessageBox / macOS `osascript` / Linux `notify-send`) so you can step away without polling.
