# SESSIONS.md — Task Context for Claude Code Hooks Demo

This file is appended to the user's prompt by the `UserPromptSubmit` Claude hook
whenever the user asks _"What should I do next?"_. It gives Claude instant,
deterministic context without requiring a repo search.

---

## 🏃 Next Tasks

### Task 1 — Add CSRF Protection to `UserLogin.vue`
**Priority:** High  
**File:** `app/components/UserLogin.vue`

The login form currently has no CSRF token. Add a server-side CSRF token
endpoint at `server/api/csrf-token.ts` and inject the token as a hidden field
(or `X-CSRF-Token` header) on every form submission. Validate the token in a
Nitro middleware at `server/middleware/csrf.ts`.

**Acceptance criteria:**
- Token is a cryptographically random UUID generated per session.
- Requests without a valid token receive a `403 Forbidden`.
- Existing login flow still works end-to-end.

---

### Task 2 — Harden Password Validation
**Priority:** High  
**File:** `app/components/UserLogin.vue`, `server/api/login.ts` (to be created)

Move credential validation out of the Vue component and into a server route so
credentials are never exposed to the client. Use `bcryptjs` to hash and compare
passwords, and add a simple in-memory rate-limiter (max 5 attempts per IP per
minute).

**Acceptance criteria:**
- `UserLogin.vue` only calls `POST /api/login` with `{ username, password }`.
- Server compares against a bcrypt hash (dummy hash acceptable for demo).
- After 5 failed attempts the endpoint returns `429 Too Many Requests`.

---

### Task 3 — Write Vitest Unit Tests for `useSprintData`
**Priority:** Medium  
**File:** `app/composables/useSprintData.ts`

Add a `tests/` directory with at least two Vitest tests:
1. `useSprintData` returns an array of `SprintItem` objects on success.
2. `useSprintData` sets `error` when the API returns a non-2xx status.

Use `@nuxt/test-utils` for composable testing and mock `useFetch` via `vi.mock`.

**Acceptance criteria:**
- `npm test` runs and all tests pass.
- Coverage for the composable is ≥ 80 %.

---

_Last updated: 2026-04-24_
