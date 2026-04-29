// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: "2025-04-01",
  devtools: { enabled: true },

  // Nuxt 4 app directory layout
  future: {
    compatibilityVersion: 4,
  },

  nitro: {
    preset: "node-server",
  },
});
