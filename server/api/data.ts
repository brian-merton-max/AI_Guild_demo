/**
 * GET /api/data
 *
 * Simulates a sprint-data endpoint for the MCP-style AI Hooks demo.
 * In a real project this would query a database or a project-management API.
 */
export default defineEventHandler(() => {
  return [
    { id: 1, title: "Scaffold Nuxt 4 project", status: "done" },
    { id: 2, title: "Add CSRF protection to UserLogin", status: "in-progress" },
    { id: 3, title: "Write unit tests for auth composable", status: "todo" },
    { id: 4, title: "Integrate security-guard hook", status: "done" },
    { id: 5, title: "Deploy to staging environment", status: "blocked" },
  ];
});
