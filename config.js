// ============================================================
// CONFIGURACAO — PROMPT LAB
// ============================================================
// Credenciais devem vir de env.js, gerado no deploy do GitHub
// Pages a partir de GitHub Secrets. Veja env.example.js.
//
// Em GitHub Pages, qualquer chave usada pelo navegador fica
// visivel para quem abre o site. Use spending limit no OpenRouter.
// A anon key do Supabase e publica por design quando protegida
// por RLS.
// ============================================================

const ENV = window.PROMPT_LAB_ENV || {};

const CONFIG = {
  // ---- Credenciais/runtime ----
  OPENROUTER_KEY: ENV.OPENROUTER_KEY || "",
  SUPABASE_URL: ENV.SUPABASE_URL || "",
  SUPABASE_ANON_KEY: ENV.SUPABASE_ANON_KEY || "",

  // ---- Modelos ----
  MODELS: [
    {
      id: "openai/gpt-5.1",
      name: "GPT-5.1",
      provider: "OpenAI",
      costIn: 1.25,
      costOut: 10.0,
      datacenter: "OpenRouter / OpenAI",
      country: "US",
      flag: "🇺🇸",
      color: "#10B981",
      tier: "Frontier",
      supportsReasoning: true,
      reasoningMode: "native"
    },
    {
      id: "openai/gpt-oss-120b",
      name: "GPT-OSS 120B",
      provider: "OpenAI (open)",
      costIn: 0.15,
      costOut: 0.60,
      datacenter: "Provedores OpenRouter",
      country: "US",
      flag: "🇺🇸",
      color: "#0EA5E9",
      tier: "Open",
      supportsReasoning: true,
      reasoningMode: "native"
    },
    {
      id: "google/gemini-2.5-flash",
      name: "Gemini 2.5 Flash",
      provider: "Google",
      costIn: 0.15,
      costOut: 0.60,
      datacenter: "Google Cloud",
      country: "US",
      flag: "🇺🇸",
      color: "#3B82F6",
      tier: "Mid-tier",
      supportsReasoning: true,
      reasoningMode: "extended-thinking"
    },
    {
      id: "qwen/qwen3-max-thinking",
      name: "Qwen3 Max Thinking",
      provider: "Qwen",
      costIn: 0.60,
      costOut: 2.40,
      datacenter: "Provedores OpenRouter",
      country: "CN",
      flag: "🇨🇳",
      color: "#8B5CF6",
      tier: "Reasoning",
      supportsReasoning: true,
      reasoningMode: "native"
    },
    {
      id: "deepseek/deepseek-r1",
      name: "DeepSeek R1",
      provider: "DeepSeek",
      costIn: 0.55,
      costOut: 2.19,
      datacenter: "Hangzhou, China",
      country: "CN",
      flag: "🇨🇳",
      color: "#EF4444",
      tier: "Budget",
      supportsReasoning: true,
      reasoningMode: "native"
    }
  ]
};
