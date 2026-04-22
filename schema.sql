-- ============================================================
-- SCHEMA: Prompt Lab — Análise Econômica do Direito com IA
-- ============================================================
-- Execute este SQL no Supabase SQL Editor (supabase.com → seu projeto → SQL Editor)
-- Cole tudo de uma vez e clique "Run"
-- ============================================================

-- Sessões de aula
CREATE TABLE sessions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  professor TEXT DEFAULT 'Professor',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Alunos
CREATE TABLE students (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Cada rodada de prompt
CREATE TABLE prompts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  session_id UUID REFERENCES sessions(id),
  student_id UUID REFERENCES students(id),
  prompt_text TEXT NOT NULL,
  system_prompt TEXT,
  temperature REAL DEFAULT 0.7,
  max_tokens INTEGER DEFAULT 1024,
  thinking_enabled BOOLEAN DEFAULT false,
  reasoning_effort TEXT DEFAULT 'medium',
  safety_prompt_applied BOOLEAN DEFAULT false,
  aed_method_applied BOOLEAN DEFAULT false,
  prompt_eixo TEXT,
  parent_prompt_id UUID REFERENCES prompts(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Cada resposta individual (1 prompt gera 5 responses)
CREATE TABLE responses (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  prompt_id UUID REFERENCES prompts(id),
  model_id TEXT NOT NULL,
  model_name TEXT NOT NULL,
  response_text TEXT,
  reasoning_text TEXT,
  reasoning_tokens INTEGER,
  reasoning_effort TEXT,
  tokens_input INTEGER,
  tokens_output INTEGER,
  cost_input REAL,
  cost_output REAL,
  cost_total REAL,
  response_time_ms INTEGER,
  datacenter_location TEXT,
  datacenter_country TEXT,
  provider TEXT,
  error_message TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE prompts ENABLE ROW LEVEL SECURITY;
ALTER TABLE responses ENABLE ROW LEVEL SECURITY;

-- Inserção e leitura pública (contexto de aula)
CREATE POLICY "insert_sessions" ON sessions FOR INSERT WITH CHECK (true);
CREATE POLICY "read_sessions" ON sessions FOR SELECT USING (true);
CREATE POLICY "insert_students" ON students FOR INSERT WITH CHECK (true);
CREATE POLICY "read_students" ON students FOR SELECT USING (true);
CREATE POLICY "insert_prompts" ON prompts FOR INSERT WITH CHECK (true);
CREATE POLICY "read_prompts" ON prompts FOR SELECT USING (true);
CREATE POLICY "insert_responses" ON responses FOR INSERT WITH CHECK (true);
CREATE POLICY "read_responses" ON responses FOR SELECT USING (true);

-- ============================================================
-- VIEWS úteis para o professor
-- ============================================================

-- Resumo por modelo
CREATE VIEW model_summary AS
SELECT
  model_name,
  COUNT(*) AS total_responses,
  ROUND(AVG(tokens_input)::numeric, 0) AS avg_tokens_in,
  ROUND(AVG(tokens_output)::numeric, 0) AS avg_tokens_out,
  ROUND(AVG(response_time_ms)::numeric, 0) AS avg_time_ms,
  ROUND(SUM(cost_total)::numeric, 6) AS total_cost,
  ROUND(AVG(cost_total)::numeric, 6) AS avg_cost
FROM responses
WHERE error_message IS NULL
GROUP BY model_name
ORDER BY total_cost DESC;

-- Histórico completo
CREATE VIEW full_history AS
SELECT
  s.name AS session_name,
  st.name AS student_name,
  p.prompt_text,
  p.temperature,
  p.prompt_eixo,
  p.thinking_enabled,
  p.safety_prompt_applied,
  p.aed_method_applied,
  r.model_name,
  r.response_text,
  r.reasoning_text,
  r.reasoning_tokens,
  r.reasoning_effort,
  r.tokens_input,
  r.tokens_output,
  r.cost_total,
  r.response_time_ms,
  r.datacenter_location,
  r.created_at
FROM responses r
JOIN prompts p ON r.prompt_id = p.id
LEFT JOIN students st ON p.student_id = st.id
LEFT JOIN sessions s ON p.session_id = s.id
ORDER BY r.created_at DESC;

-- Comparativo de raciocínio (CoT) por modelo — quanto cada modelo "pensa"
CREATE VIEW reasoning_comparison AS
SELECT
  model_name,
  COUNT(*) FILTER (WHERE reasoning_text IS NOT NULL)               AS with_cot,
  COUNT(*) FILTER (WHERE reasoning_text IS NULL)                   AS without_cot,
  ROUND(AVG(reasoning_tokens)::numeric, 0)                          AS avg_reasoning_tokens,
  ROUND(AVG(LENGTH(reasoning_text))::numeric, 0)                    AS avg_reasoning_chars,
  ROUND(AVG(LENGTH(response_text))::numeric, 0)                     AS avg_answer_chars,
  ROUND(AVG(reasoning_tokens::float / NULLIF(tokens_output, 0))::numeric, 2) AS reasoning_ratio
FROM responses
WHERE error_message IS NULL
GROUP BY model_name
ORDER BY avg_reasoning_tokens DESC NULLS LAST;

-- Custo por sessão
CREATE VIEW session_costs AS
SELECT
  s.name AS session_name,
  s.created_at AS session_date,
  COUNT(DISTINCT p.id) AS total_prompts,
  COUNT(r.id) AS total_responses,
  ROUND(SUM(r.cost_total)::numeric, 4) AS total_cost_usd
FROM sessions s
JOIN prompts p ON p.session_id = s.id
JOIN responses r ON r.prompt_id = p.id
GROUP BY s.id, s.name, s.created_at
ORDER BY s.created_at DESC;

-- Uso por aluno
CREATE VIEW student_usage AS
SELECT
  st.name AS student_name,
  COUNT(DISTINCT p.id) AS total_prompts,
  COUNT(r.id) AS total_responses,
  ROUND(SUM(r.cost_total)::numeric, 4) AS total_cost_usd
FROM students st
JOIN prompts p ON p.student_id = st.id
JOIN responses r ON r.prompt_id = p.id
GROUP BY st.name
ORDER BY total_prompts DESC;

-- ============================================================
-- MIGRAÇÃO PARA BANCOS JÁ CRIADOS
-- ============================================================
-- Se você já rodou a versão anterior deste schema, execute APENAS
-- o bloco abaixo no SQL Editor para adicionar as colunas de CoT
-- sem recriar as tabelas. É idempotente (pode rodar várias vezes).
-- ============================================================

ALTER TABLE prompts
  ADD COLUMN IF NOT EXISTS thinking_enabled      BOOLEAN DEFAULT false,
  ADD COLUMN IF NOT EXISTS reasoning_effort      TEXT DEFAULT 'medium',
  ADD COLUMN IF NOT EXISTS safety_prompt_applied BOOLEAN DEFAULT false,
  ADD COLUMN IF NOT EXISTS aed_method_applied    BOOLEAN DEFAULT false,
  ADD COLUMN IF NOT EXISTS prompt_eixo           TEXT,
  ADD COLUMN IF NOT EXISTS parent_prompt_id      UUID REFERENCES prompts(id);

ALTER TABLE responses
  ADD COLUMN IF NOT EXISTS reasoning_text    TEXT,
  ADD COLUMN IF NOT EXISTS reasoning_tokens  INTEGER,
  ADD COLUMN IF NOT EXISTS reasoning_effort  TEXT;

-- Recriar views que usam as novas colunas
DROP VIEW IF EXISTS full_history;
DROP VIEW IF EXISTS reasoning_comparison;
DROP VIEW IF EXISTS student_usage;

CREATE VIEW full_history AS
SELECT
  s.name AS session_name,
  st.name AS student_name,
  p.prompt_text,
  p.temperature,
  p.prompt_eixo,
  p.thinking_enabled,
  p.safety_prompt_applied,
  p.aed_method_applied,
  r.model_name,
  r.response_text,
  r.reasoning_text,
  r.reasoning_tokens,
  r.reasoning_effort,
  r.tokens_input,
  r.tokens_output,
  r.cost_total,
  r.response_time_ms,
  r.datacenter_location,
  r.created_at
FROM responses r
JOIN prompts p ON r.prompt_id = p.id
LEFT JOIN students st ON p.student_id = st.id
LEFT JOIN sessions s ON p.session_id = s.id
ORDER BY r.created_at DESC;

CREATE VIEW reasoning_comparison AS
SELECT
  model_name,
  COUNT(*) FILTER (WHERE reasoning_text IS NOT NULL)                        AS with_cot,
  COUNT(*) FILTER (WHERE reasoning_text IS NULL)                            AS without_cot,
  ROUND(AVG(reasoning_tokens)::numeric, 0)                                   AS avg_reasoning_tokens,
  ROUND(AVG(LENGTH(reasoning_text))::numeric, 0)                             AS avg_reasoning_chars,
  ROUND(AVG(LENGTH(response_text))::numeric, 0)                              AS avg_answer_chars,
  ROUND(AVG(reasoning_tokens::float / NULLIF(tokens_output, 0))::numeric, 2) AS reasoning_ratio
FROM responses
WHERE error_message IS NULL
GROUP BY model_name
ORDER BY avg_reasoning_tokens DESC NULLS LAST;

CREATE VIEW student_usage AS
SELECT
  st.name AS student_name,
  COUNT(DISTINCT p.id) AS total_prompts,
  COUNT(r.id) AS total_responses,
  ROUND(SUM(r.cost_total)::numeric, 4) AS total_cost_usd
FROM students st
JOIN prompts p ON p.student_id = st.id
JOIN responses r ON r.prompt_id = p.id
GROUP BY st.name
ORDER BY total_prompts DESC;
