# Prompt Lab — Análise Econômica do Direito com IA

Aplicação web para comparar respostas de 5 LLMs lado a lado, com captura de raciocínio (Chain-of-Thought), métricas de custo/tokens/tempo e persistência no Supabase. Ferramenta pedagógica para ensino de AED + Prompt Engineering.

Referência: Resende, G.M. — *AED com IA Generativa: um manual prático de prompts* (2026).

## Modelos incluídos

| Modelo | Empresa | Custo/1M tokens (in → out) | Reasoning | Datacenter |
|--------|---------|----------------------------|-----------|------------|
| GPT-5.1 | OpenAI | $1.25 → $10.00 | Nativo | 🇺🇸 OpenRouter/OpenAI |
| GPT-OSS 120B | OpenAI (open) | $0.15 → $0.60 | Nativo | 🇺🇸 OpenRouter |
| Gemini 2.5 Flash | Google | $0.15 → $0.60 | Extended thinking | 🇺🇸 Google Cloud |
| Qwen3 Max Thinking | Qwen | $0.60 → $2.40 | Nativo | 🇨🇳 OpenRouter |
| DeepSeek R1 | DeepSeek | $0.55 → $2.19 | Nativo | 🇨🇳 Hangzhou |

> Os custos em `config.js` são estimativas para cálculo pedagógico no dashboard. Confira os preços atuais no OpenRouter antes de usar em produção.

## Raciocínio (CoT)

A plataforma captura o raciocínio interno dos modelos via OpenRouter (`message.reasoning` / `message.reasoning_details`). Cada card de resposta abre um modal com:

- **🧠 Raciocínio do modelo** — seção colapsável com o CoT completo e badge de tokens de reasoning
- **🔁 Stress test** — botão que dispara o Prompt 72 do ebook (autocrítica estrutural) no mesmo modelo, ligando a resposta-filha à resposta original via `parent_prompt_id` no Supabase

O toggle **🧠 Mostrar raciocínio (CoT)** no input, combinado com o seletor de esforço (baixo/médio/alto), controla se o campo `reasoning` é enviado na chamada à API.

## Toggles integrados do ebook

| Toggle | Prompt do ebook | O que faz |
|--------|----------------|-----------|
| 🛡️ Prompt de segurança | Prompt 23 | Prepend anti-alucinação: proíbe inventar leis/precedentes, separa fato/inferência/sugestão, exige lista de lacunas |
| 📐 Método AED 7 passos | Prompt 74 (síntese) | Envelope que força a resposta nos 7 passos canônicos do método AED |
| Eixo temático | — | Classifica o prompt no Supabase (`prompt_eixo`) para análise posterior |

## Biblioteca de prompts (ebook)

O botão **📚 Biblioteca AED do ebook** exibe 5 prompts curados de `docs/prompts-direito.json`:

| # | Eixo | Origem no ebook | O que demonstra |
|---|------|-----------------|-----------------|
| 1 | meta | Prompt 74 (cap. 18.8) | Método AED 7 passos aplicado ao caso do aluno |
| 2 | contratos | Caso 1 (cap. 7.2) + Prompt 40 | Cláusula de exclusividade: hold-up, free-riding, investimento específico |
| 3 | responsabilidade | Prompt 46 + Caso 2 | Dano ambiental: prevenção ótima, under/over-deterrence |
| 4 | coase | cap. 12 | Teorema de Coase com altos custos de transação no Brasil |
| 5 | meta | Prompt 72 (cap. 18.2) | Stress test — autocrítica estrutural (alimenta também o botão 🔁) |

Cada prompt carrega `temperature`, `reasoning_effort`, `eixo`, `objetivo_pedagogico` e `falha_esperada_ia`.

## Setup rápido (30 minutos)

### 1. OpenRouter

1. Crie conta em [openrouter.ai](https://openrouter.ai)
2. Adicione créditos (US$ 5-10 bastam para um semestre)
3. Vá em **Settings → API Keys** → crie uma key com spending limit de $2
4. Copie a key

### 2. Supabase

1. Crie conta em [supabase.com](https://supabase.com)
2. Crie um novo projeto (região: South America — São Paulo)
3. Vá em **SQL Editor** → cole todo o conteúdo de `schema.sql` → clique **Run**
4. Vá em **Settings → API** → copie a **Project URL** e a **anon/public key**

> **Banco já existente?** Cole apenas o bloco `ALTER TABLE ... ADD COLUMN IF NOT EXISTS` no final de `schema.sql` — é idempotente. Ver detalhes em [docs/setup-guide.md](docs/setup-guide.md).

### 3. Configuração local

Crie um arquivo `env.js` local a partir de `env.example.js`:

```javascript
window.PROMPT_LAB_ENV = {
  OPENROUTER_KEY: "sk-or-v1-SUA-KEY-AQUI",
  SUPABASE_URL: "https://seu-projeto.supabase.co",
  SUPABASE_ANON_KEY: "eyJ..."
};
```

`env.js` está no `.gitignore` e não deve ser versionado. `config.js` fica apenas com modelos e leitura das variáveis runtime.

### 4. Deploy no GitHub Pages

1. Crie o repositório no GitHub e envie os arquivos.
2. Em **Settings → Secrets and variables → Actions**, crie os secrets:
   - `OPENROUTER_KEY`
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
3. Em **Settings → Pages**, selecione **Source: GitHub Actions**.
4. O workflow `.github/workflows/pages.yml` gera o `env.js` durante o deploy.
5. Acesse: `https://seu-usuario.github.io/nome-do-repo/`

## Antes de cada aula (2 min)

1. No OpenRouter: gere uma nova API key com limite de $2
2. Atualize o secret `OPENROUTER_KEY` no GitHub
3. Verifique se o Supabase não está pausado

## Após cada aula (1 min)

1. No OpenRouter: delete/revogue a key usada
2. (Opcional) Exporte os dados no Dashboard (CSV ou JSON)

## Estrutura

```
prompt-lab/
├── index.html            ← Aplicação React completa (single file)
├── config.js             ← Leitura de env.js e lista de modelos
├── env.example.js        ← Modelo para configuração local
├── schema.sql            ← SQL para Supabase (inclui migração incremental)
├── .github/workflows/    ← Deploy GitHub Pages com secrets
├── README.md
└── docs/
    ├── prompts-direito.json   ← 5 prompts curados do ebook
    ├── reflexoes-aed-ia.md    ← Falhas da IA em AED + roadmap
    └── setup-guide.md
```

## Custo estimado

| Cenário | Custo |
|---------|-------|
| Infraestrutura (GitHub Pages + Supabase Free) | $0 |
| Por rodada (1 prompt × 5 modelos, CoT desligado) | ~$0.01–0.03 |
| Por rodada com CoT alto | ~$0.05–0.20 |
| Por aula (~20 rodadas) | ~$0.50–1.50 |
| Por semestre (10 aulas) | ~$5–15 |

## Segurança

- A chave OpenRouter é injetada em `env.js` no deploy via GitHub Secrets
- Em GitHub Pages, qualquer chave usada pelo navegador fica visível no client; use spending limit e revogue a key após a aula
- A anon key do Supabase é pública por design — protegida por RLS configurado no `schema.sql`
- Não versionar `env.js`

## Funcionalidades

- ⚡ Envio paralelo para 5 modelos via OpenRouter
- 🧠 Captura e exibição de raciocínio (CoT) com badge de reasoning tokens
- 🌓 Alternância entre modo claro e modo escuro
- 🪟 Resultado completo de cada modelo em modal clicável
- 🔁 Stress test por modelo (Prompt 72 do ebook — autocrítica estrutural)
- 🛡️ Toggle de prompt de segurança (Prompt 23 — anti-alucinação)
- 📐 Toggle do método AED 7 passos (Prompt 74 — síntese)
- 📚 Biblioteca de 5 prompts curados do ebook, carregáveis com um clique
- 🏷️ Classificação por eixo temático persistida no Supabase
- 📊 Gráficos de custo, tokens e tempo por modelo
- 🧪 Dashboard com tabela de reasoning por modelo (view `reasoning_comparison`)
- 🗄️ Persistência completa: prompt + reasoning + metadados no Supabase
- 👨‍🎓 Identificação apenas por nome
- 📥 Exportação CSV e JSON da sessão completa

---

Desenvolvido para o curso **Análise Econômica do Direito com IA** — IDP.
