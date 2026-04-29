<template>
  <main class="home">
    <h1>🪝 AI Hooks Demo</h1>
    <p class="subtitle">
      Deterministic guardrails that the AI agent <em>cannot</em> bypass.
    </p>

    <section>
      <h2>UserLogin.vue — Security Hook Target</h2>
      <p class="hint">
        This component has intentional security flaws. The
        <code>security-guard</code> PreToolUse hook will block any AI
        attempting to save a file containing
        <code>DANGEROUS_PLAINTEXT_PASSWORD</code>.
      </p>
      <UserLogin />
    </section>

    <section>
      <h2>Sprint Data — MCP-style Hook Demo</h2>
      <p class="hint">
        Data is fetched from <code>/api/data</code>. The PostToolUse
        <code>format</code> hook runs Prettier on every file the AI edits.
      </p>
      <SprintData />
    </section>
  </main>
</template>

<script setup lang="ts">
useHead({ title: "AI Hooks Demo" });
</script>

<style scoped>
.home {
  max-width: 820px;
  margin: 2rem auto;
  font-family: system-ui, sans-serif;
  color: #111;
}
.subtitle {
  color: #555;
  margin-bottom: 2rem;
}
section {
  margin-top: 2rem;
  padding: 1.25rem;
  border: 1px solid #ddd;
  border-radius: 10px;
  background: #fafafa;
}
section h2 {
  margin-top: 0;
}
.hint {
  font-size: 0.85rem;
  color: #666;
  margin-bottom: 1rem;
}
</style>
