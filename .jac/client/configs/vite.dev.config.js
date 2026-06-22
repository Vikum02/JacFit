import { defineConfig } from "vite";
import path from "path";
import { fileURLToPath } from "url";
import react from "@vitejs/plugin-react";
const __dirname = path.dirname(fileURLToPath(import.meta.url));
const buildDir = path.resolve(__dirname, "..");
const projectRoot = path.resolve(__dirname, "../../..");

// Vite plugin: forward client-side runtime errors to the terminal via WebSocket
function jacErrorReporter() {
  const seen = new Map();
  return {
    name: "jac-error-reporter",
    configureServer(server) {
      server.ws.on("jac:client-error", (data) => {
        const key = data.type + ":" + data.message;
        const now = Date.now();
        if (seen.get(key) > now - 2000) return;
        seen.set(key, now);
        let loc = "";
        if (data.source) {
          try {
            var p = new URL(data.source).pathname.slice(1)
              .replace("compiled/", "").replace(".vite/deps/", "");
            if (p.endsWith(".js")) p = p.slice(0, -3) + ".jac";
            loc = " (" + p;
            if (data.line) loc += ":" + data.line;
            if (data.column) loc += ":" + data.column;
            loc += ")";
          } catch(e) {}
        }
        console.error("Client error: " + data.type + ": " + data.message + loc);
      });
    },
  };
}

/**
 * Vite DEV configuration for HMR mode
 * Proxies API routes to Python server at localhost:8001
 */
export default defineConfig({
  base: "/",
  define: {

  },
  plugins: [
    jacErrorReporter(),
    react()
  ],
  root: buildDir,
  envDir: projectRoot, // Load .env files from project root
  publicDir: false,
  appType: 'spa',
  build: {
    sourcemap: true, // Enable source maps for better error messages
  },
  server: {
    host: true,
    watch: {
      usePolling: true,
      interval: 100,
    },
    proxy: {
      "/walker": {
        target: "http://localhost:8001",
        changeOrigin: true,
      },
      "/function": {
        target: "http://localhost:8001",
        changeOrigin: true,
      },
      "/user": {
        target: "http://localhost:8001",
        changeOrigin: true,
      },
      "/introspect": {
        target: "http://localhost:8001",
        changeOrigin: true,
      },
      "/static": {
        target: "http://localhost:8001",
        changeOrigin: true,
      },
      "/docs": {
        target: "http://localhost:8001",
        changeOrigin: true,
      },
      "/openapi.json": {
        target: "http://localhost:8001",
        changeOrigin: true,
      },
      "/admin": {
        target: "http://localhost:8001",
        changeOrigin: true,
      },
      "/graph": {
        target: "http://localhost:8001",
        changeOrigin: true,
      },
      "/redoc": {
        target: "http://localhost:8001",
        changeOrigin: true,
      },
      // Backend serves project assets/ dir in dev; Vite owns /assets/* only at build time.
      "/assets": {
        target: "http://localhost:8001",
        changeOrigin: true,
      },
    },

  },
  resolve: {
    alias: {
      "@jac/runtime": path.resolve(buildDir, "compiled/client_runtime.js"),
      "@jac-client/assets": path.resolve(buildDir, "compiled/assets"),
    },
    extensions: [".mjs", ".js", ".mts", ".ts", ".jsx", ".tsx", ".json"],

  },
});
