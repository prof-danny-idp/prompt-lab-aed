# Guia de Setup Detalhado — Prompt Lab

## Passo 1: Criar conta no OpenRouter

1. Acesse [openrouter.ai](https://openrouter.ai)
2. Clique em **Sign Up** (pode usar Google ou GitHub)
3. Vá em **Settings → Credits** → adicione US$ 5-10
4. Vá em **Settings → API Keys** → clique **Create Key**
   - Nome: `aula-2026-05-01`
   - Credit limit: `2` (dólares)
5. Copie a key gerada (começa com `sk-or-v1-`)

> **Dica**: Crie uma key nova para cada aula. Após a aula, delete a key antiga.

## Passo 2: Criar projeto no Supabase

1. Acesse [supabase.com](https://supabase.com) → **Start your project**
2. Crie uma organização (ex: "Faculdade")
3. Clique **New Project**
   - Nome: `prompt-lab`
   - Senha do banco: anote em lugar seguro
   - Região: escolha a mais próxima (ex: South America (São Paulo))
4. Aguarde ~2 minutos até o projeto ficar pronto

## Passo 3: Criar as tabelas

1. No painel do Supabase, clique em **SQL Editor** (menu lateral)
2. Clique **New Query**
3. Abra o arquivo `schema.sql` do projeto
4. Copie **todo** o conteúdo e cole no editor SQL
5. Clique **Run** (botão verde)
6. Deve aparecer "Success. No rows returned" — está correto!

> **Banco já existente (versão anterior do Prompt Lab)?**
> Se você já rodou o `schema.sql` em uma versão anterior, **não recrie as tabelas**. Cole apenas o bloco de migração no final do arquivo — ele é idempotente (pode rodar várias vezes sem risco):
>
> ```sql
> ALTER TABLE prompts
>   ADD COLUMN IF NOT EXISTS thinking_enabled      BOOLEAN DEFAULT false,
>   ADD COLUMN IF NOT EXISTS reasoning_effort      TEXT DEFAULT 'medium',
>   ADD COLUMN IF NOT EXISTS safety_prompt_applied BOOLEAN DEFAULT false,
>   ADD COLUMN IF NOT EXISTS aed_method_applied    BOOLEAN DEFAULT false,
>   ADD COLUMN IF NOT EXISTS prompt_eixo           TEXT,
>   ADD COLUMN IF NOT EXISTS parent_prompt_id      UUID REFERENCES prompts(id);
>
> ALTER TABLE responses
>   ADD COLUMN IF NOT EXISTS reasoning_text    TEXT,
>   ADD COLUMN IF NOT EXISTS reasoning_tokens  INTEGER,
>   ADD COLUMN IF NOT EXISTS reasoning_effort  TEXT;
> ```
>
> Depois recriar as views que usam as novas colunas (os `DROP VIEW IF EXISTS` + `CREATE VIEW` no final do `schema.sql`).
> Para verificar se a migração funcionou:
> ```sql
> SELECT column_name FROM information_schema.columns
> WHERE table_name = 'responses'
> ORDER BY column_name;
> ```
> A coluna `reasoning_text` deve aparecer na lista.

## Passo 4: Copiar credenciais do Supabase

1. No painel, vá em **Settings** (engrenagem) → **API**
2. Copie:
   - **Project URL**: algo como `https://abcdefgh.supabase.co`
   - **anon public key**: começa com `eyJ...` (é longa)

> A anon key é **pública por design**. Ela é protegida pelo Row Level Security (RLS) que configuramos no SQL.

## Passo 5: Configurar o projeto local

1. Copie `env.example.js` para `env.js`
2. Preencha os valores:

```javascript
window.PROMPT_LAB_ENV = {
  OPENROUTER_KEY: "sk-or-v1-sua-chave-openrouter",
  SUPABASE_URL: "https://seu-projeto.supabase.co",
  SUPABASE_ANON_KEY: "sua-anon-public-key"
};
```

`env.js` não deve ir para o GitHub. Ele está listado no `.gitignore`.

> Importante: no GitHub Pages, o `env.js` final é entregue ao navegador. A chave OpenRouter continua visível para quem inspecionar a página; por isso, use limite de gasto baixo e revogue a chave após a atividade.

## Passo 6: Subir no GitHub

### Opção A — Pela interface web do GitHub

1. Crie um novo repositório **privado** no GitHub
2. Clique **Upload files**
3. Arraste todos os arquivos do projeto
4. Commit

### Opção B — Pelo terminal

```bash
cd prompt-lab
git init
git add .
git commit -m "setup inicial"
git remote add origin https://github.com/SEU-USUARIO/prompt-lab.git
git push -u origin main
```

## Passo 7: Ativar GitHub Pages

1. No repositório, vá em **Settings → Secrets and variables → Actions**
2. Crie três secrets:
   - `OPENROUTER_KEY`
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
3. Vá em **Settings → Pages**
4. Source: **GitHub Actions**
5. Faça push na branch `main`
6. O workflow `.github/workflows/pages.yml` vai gerar o `env.js` durante o deploy
7. O site estará em: `https://seu-usuario.github.io/prompt-lab/`

## Verificação

Acesse o site e verifique:
- ✅ Tela de login aparece
- ✅ Barra de status mostra "🟢 BD conectado" e "🟢 API OK"
- ✅ Envie um prompt de teste → respostas devem aparecer
- ✅ No Supabase → Table Editor → tabela `responses` deve ter dados

## Troubleshooting

| Problema | Solução |
|----------|---------|
| "🔴 BD offline" | Verifique `SUPABASE_URL` e `SUPABASE_ANON_KEY` no `env.js` local ou nos GitHub Secrets |
| "🔴 API não configurada" | Verifique `OPENROUTER_KEY` no `env.js` local ou nos GitHub Secrets |
| Erro 401 no OpenRouter | Key inválida ou expirada. Gere uma nova |
| Erro 402 no OpenRouter | Créditos esgotados. Adicione mais |
| Supabase pausado | Acesse o dashboard do Supabase e clique "Restore" |
| Modelo retorna erro | Confirme os model IDs em openrouter.ai/models |
| GitHub Pages não atualiza | Aguarde 2-3 min ou force com push vazio |
| Coluna `reasoning_text` não existe | Cole o bloco ALTER TABLE do Passo 3 acima no SQL Editor |
| CoT não aparece no modal | Verifique se o toggle 🧠 está ativado e se o modelo retornou reasoning via OpenRouter |
| Dashboard "Reasoning" vazio | Faça pelo menos uma rodada com CoT ativado — a view `reasoning_comparison` precisa de dados |
