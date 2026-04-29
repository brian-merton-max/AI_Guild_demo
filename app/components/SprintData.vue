<template>
  <div class="sprint-data">
    <h3>Sprint Data</h3>
    <p v-if="pending">Loading…</p>
    <p v-else-if="error" class="error">Failed to load sprint data.</p>
    <ul v-else>
      <li v-for="item in data" :key="item.id">
        <strong>{{ item.title }}</strong>
        <span :class="['badge', item.status]">{{ item.status }}</span>
      </li>
    </ul>
  </div>
</template>

<script setup lang="ts">
const { data, pending, error } = await useSprintData();
</script>

<style scoped>
.sprint-data ul {
  list-style: none;
  padding: 0;
}
.sprint-data li {
  display: flex;
  justify-content: space-between;
  padding: 0.4rem 0;
  border-bottom: 1px solid #eee;
}
.badge {
  padding: 0.15rem 0.5rem;
  border-radius: 12px;
  font-size: 0.75rem;
  text-transform: capitalize;
}
.badge.todo      { background: #f0f0f0; color: #555; }
.badge.in-progress { background: #dbeafe; color: #1d4ed8; }
.badge.done      { background: #dcfce7; color: #16a34a; }
.badge.blocked   { background: #fee2e2; color: #dc2626; }
</style>

