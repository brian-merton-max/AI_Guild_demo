<template>
  <div class="login-form">
    <h2>Login</h2>
    <!--
      ⚠️  INTENTIONAL SECURITY ISSUES — for AI Hooks demo only.
        1. No CSRF token on the form.
        2. Password compared with plain equality (no bcrypt, no rate-limit).
        3. Error message leaks whether username or password was wrong (info-disclosure).
      The PreToolUse security-guard hook blocks any AI that tries to save a file
      containing the literal string "DANGEROUS_PLAINTEXT_PASSWORD".
    -->
    <form @submit.prevent="handleLogin">
      <label>
        Username
        <input v-model="username" type="text" autocomplete="username" />
      </label>

      <label>
        Password
        <input v-model="password" type="password" />
      </label>

      <p v-if="errorMessage" class="error">{{ errorMessage }}</p>

      <button type="submit">Sign in</button>
    </form>
  </div>
</template>

<script setup lang="ts">
const username = ref("");
const password = ref("");
const errorMessage = ref("");

/**
 * Weak login handler — intentionally insecure for the demo.
 * Missing: CSRF token, hashed passwords, account-lockout, audit logging.
 */
async function handleLogin() {
  errorMessage.value = "";

  if (username.value === "admin" && password.value === "admin123") {
    await navigateTo("/dashboard");
  } else if (username.value !== "admin") {
    // ⚠️  Leaks which field was wrong
    errorMessage.value = "Unknown username.";
  } else {
    errorMessage.value = "Incorrect password.";
  }
}
</script>

<style scoped>
.login-form {
  max-width: 360px;
  margin: 2rem auto;
  padding: 1.5rem;
  border: 1px solid #ccc;
  border-radius: 8px;
  font-family: sans-serif;
}
form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}
label {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  font-size: 0.9rem;
}
input {
  padding: 0.5rem;
  border: 1px solid #aaa;
  border-radius: 4px;
}
button {
  padding: 0.6rem;
  background: #0070f3;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
.error {
  color: red;
  font-size: 0.85rem;
}
</style>


<style scoped>
.login-form {
  max-width: 360px;
  margin: 2rem auto;
  padding: 1.5rem;
  border: 1px solid #ccc;
  border-radius: 8px;
  font-family: sans-serif;
}
form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}
label {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  font-size: 0.9rem;
}
input {
  padding: 0.5rem;
  border: 1px solid #aaa;
  border-radius: 4px;
}
button {
  padding: 0.6rem;
  background: #0070f3;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
.error {
  color: red;
  font-size: 0.85rem;
}
</style>
