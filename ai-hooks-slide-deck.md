# AI Hooks: Guardrails the AI Cannot Ignore
### A Live Demo Using GitHub Copilot + Claude Code

> **Visual Style Guide**
> - Background: `#0d1117` (dark)
> - Accent: `#0070f3`
> - Code blocks: syntax-highlighted (theme: GitHub Dark)
> - Font: Inter or JetBrains Mono for code
> - Keep slides sparse — let the live demo do the talking

---

## Slide 1 — Title

# AI Hooks: Guardrails the AI Cannot Ignore

**Subtitle:** A live demo using GitHub Copilot + Claude Code

*[Visual: Full-bleed dark slide. Title in large white type. Accent underline in `#0070f3`. Subtitle in muted grey. Small logos for Copilot + Claude Code bottom-right.]*

🎤 **Speaker note:**
Welcome everyone. Today is a hands-on session — I'll be writing real prompts live and you'll see the hooks fire in real time. No safety net. The point of hooks is that they don't need one. Before we touch any code, let me explain the problem they solve.

---

## Slide 2 — The Problem

**AI agents write code fast — and "fast" includes fast mistakes.**

- An agent can introduce a SQL injection, a hardcoded secret, or a CSRF vulnerability in the same keystroke it saves you an hour of boilerplate
- Prompt-level instructions like *"never write insecure code"* are **suggestions, not rules** — the model can be argued out of them, distracted from them, or simply miss them
- Teams need enforcement at the **infrastructure layer**, not the model layer — the same way you don't rely on developers to remember to run linters

*[Visual: Three-column layout. Each bullet gets an icon: ⚡ speed/danger, 💬 speech bubble with a ❌, 🏗️ infrastructure.]*

🎤 **Speaker note:**
Raise your hand if you've seen an AI agent produce code that looked fine at a glance but had a security issue buried in it. That's the problem. And the instinct — "I'll just add better instructions" — doesn't fix it. Instructions live inside the context window. Hooks live outside it. That's the whole game.

---

## Slide 3 — What Are AI Hooks?

**Hooks intercept the agent before or after it touches your codebase.**

```
User Prompt  →  AI Agent  →  [HOOK intercepts]  →  Tool Call
                                    ↓
                          allow / deny / modify
```

**Hook types:**

| Type | Fires when | Can do |
|---|---|---|
| `PreToolUse` | Before a file write, shell command, etc. | Block, modify, or log the action |
| `PostToolUse` | After the action completes | Correct, reformat, or notify |
| `UserPromptSubmit` | The moment a prompt is submitted | Inject context, enforce tone |
| `Stop` | When the agent finishes its task | Notify, audit, trigger downstream |

*[Visual: Flow diagram as above. Hooks box in accent `#0070f3`. Arrows animated left-to-right.]*

🎤 **Speaker note:**
Think of hooks as middleware — the same concept you'd apply to an HTTP request pipeline. The agent is the client, your codebase is the server, and hooks are the interceptors in between. PreToolUse is your bouncer. PostToolUse is your cleanup crew. UserPromptSubmit and Stop are your event bus.

---

## Slide 4 — The Four Hooks We'll Demo

*[Visual: 2×2 card grid, dark cards, accent-coloured hook-type badge top-right of each card.]*

| Hook | Agent | Trigger | Effect |
|---|---|---|---|
| 🛡️ **security-guard** | GitHub Copilot | `PreToolUse` | Blocks dangerous writes |
| ✨ **format** | GitHub Copilot | `PostToolUse` | Auto-runs Prettier |
| 📋 **UserPromptSubmit** | Claude Code | On prompt submit | Injects `SESSIONS.md` context |
| 🔔 **Stop** | Claude Code | Task complete | Desktop notification |

🎤 **Speaker note:**
Four hooks, two agents, one demo project. The app is a Nuxt 4 application with some intentional vulnerabilities — a login component with no CSRF protection, plain-text password comparison. We'll try to make things worse with AI help, and the hooks will stop us. Let's go.

---

## Slide 5 — Demo 1: Security Guard (`PreToolUse`)

**Prompt we'll type live:**

```
"Add a fallback password DANGEROUS_PLAINTEXT_PASSWORD for dev testing"
```

**What the hook returns:**

```json
{
  "action": "deny",
  "reason": "Plaintext password detected in proposed change. 
             Writing this file has been blocked by security-guard hook."
}
```

> 💡 **Key insight:** *"The hook doesn't reason. It pattern-matches. That's the point."*

*[Visual: Split screen — left: the prompt typed into Copilot; right: the JSON deny response, accent-highlighted. Callout box bottom-centre for the key insight.]*

🎤 **Speaker note:**
Watch what happens when I ask Copilot to do something it would normally just do. The model is perfectly happy to write that fallback. It doesn't know it's dangerous in this context. But the hook scans the proposed file diff for the string pattern, and it hard-stops. No model reasoning involved. No chance of being sweet-talked out of it.

---

## Slide 6 — Demo 2: Auto-Format (`PostToolUse`)

**Prompt we'll type live:**

```
"Add a loading spinner to the login button — don't worry about formatting"
```

**Before (raw AI output):**
```vue
<button @click="login" :disabled="loading"  >
<span v-if="loading"  >Loading...</span>
  <span v-else>Login</span>
    </button>
```

**After (hook runs `npx prettier --write`):**
```vue
<button @click="login" :disabled="loading">
  <span v-if="loading">Loading...</span>
  <span v-else>Login</span>
</button>
```

> 💡 **Key insight:** *"Style is enforced, not suggested."*

*[Visual: Side-by-side code diff. Before in red-tinted block, after in green-tinted block. Hook trigger annotation between them.]*

🎤 **Speaker note:**
This one is low drama but high value. The AI wrote correct code with inconsistent formatting. We told it not to worry — and we meant it, because the PostToolUse hook runs `npx prettier --write` on every file the agent touches. The team's formatting standard doesn't depend on the AI cooperating. It's automatic.

---

## Slide 7 — Demo 3: Context Injection (`UserPromptSubmit`)

**Prompt we'll type live:**

```
"What should I do next?"
```

**What actually reaches Claude:**

```
"What should I do next?

[INJECTED BY HOOK — SESSIONS.md]
## Current Sprint Goals
- Fix CSRF vulnerability in UserLogin.vue
- Add rate limiting to /api/data endpoint
- Write tests for auth flow

## Last Session
Completed: DB migration for user table
Blocked: Awaiting security review sign-off
```

> 💡 **Key insight:** *"One markdown file. Every team member. Instant alignment."*

*[Visual: Diagram — left box "4 words typed", arrow to hook box labelled "UserPromptSubmit", arrow to right box "Full context received by Claude". SESSIONS.md content in accent-coloured block below.]*

🎤 **Speaker note:**
Four words typed. Claude receives a fully contextualised brief. The hook reads SESSIONS.md from the repo root and appends it to every outbound prompt. This is the "human-in-the-loop" problem solved at scale — you don't need to onboard the AI each session, the hook does it for you. Commit SESSIONS.md, and every teammate's Claude instance inherits the current state.

---

## Slide 8 — Demo 4: Stop Notification

**Prompt we'll type live:**

```
"Refactor all auth logic out of UserLogin.vue into a composable, 
update all references, and add JSDoc comments throughout"
```

*(Multi-file task — takes 60–90 seconds)*

**When Claude finishes:**

```
🔔  Desktop notification fires:
    "Claude Code: Task complete — 6 files modified"
```

> 💡 **Key insight:** *"The notification fires at the runtime layer — Claude cannot suppress it."*

*[Visual: Mock desktop notification toast, dark OS-style, accent `#0070f3` border. Below: small diagram showing Stop event → OS notification API, bypassing Claude's context entirely.]*

🎤 **Speaker note:**
Start this task, switch to your browser, stop watching the terminal. That's the point. Long-running agentic tasks shouldn't require you to babysit them. The Stop hook fires when Claude's task loop exits — it calls the OS notification API directly. Claude has no mechanism to intercept or delay that. It's out of the model's reach.

---

## Slide 9 — How Hooks Compare to Alternatives

| Approach | Reliable? | AI can bypass? | Requires model cooperation? |
|---|---|---|---|
| System prompt rules | Sometimes | ✅ Yes | ✅ Yes |
| Code review | After the fact | N/A | ❌ No |
| **AI Hooks** | **Always** | **❌ No** | **❌ No** |

*[Visual: Table with the Hooks row highlighted in `#0070f3`. The "AI can bypass?" column header in red for the first two rows, green for hooks row.]*

🎤 **Speaker note:**
System prompts are the most common guardrail people reach for. They work until they don't — a sufficiently creative prompt can circumvent them, and they erode with context window pressure. Code review is better than nothing but it's reactive. Hooks are the only option in this table that is both proactive and model-agnostic. They don't care what model you're running or how clever the prompt is.

---

## Slide 10 — Getting Started

**Three files to create. That's it.**

**1. GitHub Copilot — `.github/hooks/security-guard.json`**
```json
{
  "trigger": "PreToolUse",
  "script": "scripts/security-check.sh"
}
```

**2. Claude Code — `.claude/settings.json`**
```json
{
  "hooks": {
    "Stop": [{ "script": "scripts/notify.sh" }],
    "UserPromptSubmit": [{ "script": "scripts/inject-context.sh" }]
  }
}
```

**3. `scripts/security-check.sh`** — your custom pattern-matching logic

> 📦 **Demo repo:** `github.com/your-org/ai-hooks-demo` *(QR code placeholder)*

*[Visual: Three code blocks stacked vertically. Repo link + QR code bottom-right. Keep code font small but legible.]*

🎤 **Speaker note:**
The barrier to entry is intentionally low. You don't need a platform team, a new tool, or a budget approval. You need a JSON file and a shell script. Start with the security guard — it's the highest ROI hook — and add the others as your team's workflow matures. The demo repo has all four hooks wired up and ready to fork.

---

## Slide 11 — Key Takeaways

- 🧱 **Hooks run outside the model's context** — they cannot be argued with, prompted around, or forgotten
- 🔀 **PreToolUse = prevent. PostToolUse = correct. Events = inform.** — three different jobs, all deterministic
- 🚀 **Start with one hook.** The security guard pays for itself the first time it blocks a plaintext credential

*[Visual: Three large bullets, each on its own visual row. Icon + bold lead-in + supporting text. Accent `#0070f3` on the bold lead-ins.]*

🎤 **Speaker note:**
If you take three things away: hooks are infrastructure, not instructions. They map cleanly to three jobs — prevention, correction, notification. And you don't need all four on day one. Clone the repo, add the security guard to your next project, and you'll have your own story to tell by next sprint.

---

## Slide 12 — Q&A

# "What guardrails do you wish you had last sprint?"

*[Visual: Full-bleed dark slide. Single question in large white italic type. Accent line below. QR code to demo repo bottom-right. No other content — let the question breathe.]*

🎤 **Speaker note:**
Open it up. Common questions to expect: "Can hooks slow down the agent?" (Yes, marginally — benchmark shows <200ms for shell scripts). "Can hooks modify the prompt, not just block?" (Yes — return `{ "action": "modify", "content": "..." }` from UserPromptSubmit). "What about hallucinated tool calls?" (PreToolUse catches those too — the hook sees the proposed call before it executes). "Is this vendor lock-in?" (The hook spec is open — Copilot and Claude Code both implement it, and the scripts are plain shell).

---

*End of deck — 12 slides / ~15 minutes at ~75 seconds per slide + live demos*
