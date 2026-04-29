/**
 * useSprintData — composable that fetches sprint items from /api/data.
 * Used by SprintData.vue and demonstrates the MCP-style server route hook.
 */
export interface SprintItem {
  id: number;
  title: string;
  status: "todo" | "in-progress" | "done" | "blocked";
}

export function useSprintData() {
  return useFetch<SprintItem[]>("/api/data");
}

