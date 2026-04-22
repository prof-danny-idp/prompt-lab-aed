# Reflexões — AED e onde a IA ainda falha

> Documento companheiro do [Prompt Lab](../index.html) para a disciplina **Análise Econômica do Direito com IA**.
> Referência: Resende, G.M. — *Análise Econômica do Direito (AED) com Inteligência Artificial (IA) Generativa: um manual prático de prompts* (2026).

A tese central do ebook é direta: **"sem método, a IA apenas acelera a superficialidade. Com método, ela eleva o padrão da decisão"** (cap. 20). Este documento tem três objetivos:

1. **§1** — citar literalmente os erros que o próprio ebook cataloga (cap. 19.2 e 19.3) e, para cada um, indicar **como demonstrá-lo em sala** com a biblioteca de prompts e o que observar no Chain-of-Thought (CoT) do modelo.
2. **§2** — registrar **dez falhas adicionais** observadas na prática de uso de IA generativa para Direito brasileiro, que complementam a lista do ebook.
3. **§3** — propor um **roadmap** de melhorias técnicas, pedagógicas e de segurança para a plataforma.

O instrumento pedagógico central da plataforma é a **exposição do raciocínio (CoT)**: o aluno não vê apenas o que o modelo concluiu, mas como hesitou, simplificou ou pulou etapas. É onde o método do livro e a arquitetura desta plataforma se encontram.

---

## §1. Erros reconhecidos pelo próprio ebook

### §1.1 — Os 10 erros na aplicação da AED (cap. 19.2)

| # | Erro do ebook (literal) | Como demonstrar no Prompt Lab | O que observar no CoT |
|---|--------------------------|-------------------------------|------------------------|
| 1 | **Confundir plausibilidade com evidência** — "Essa regra aumenta eficiência" sem dados. | Prompt #2 (Cláusula de exclusividade). Compare modelos: quem afirma "promove eficiência" sem citar fonte vs. quem qualifica como hipótese. | O CoT revela se o modelo *raciocinou* sobre evidência empírica ou apenas *enunciou* a conclusão. |
| 2 | **Ignorar o contrafactual** — analisar só o cenário atual, sem alternativa. | Prompt #1 (Método 7 passos) — o passo 1 exige contrafactual. Rode também sem o toggle 📐 e compare. | Sem o toggle, o CoT geralmente "salta" do problema para a conclusão sem o passo comparativo. |
| 3 | **Reduzir a AED a cálculo numérico** — AED ≠ monetização. | Prompt #3 (Dano ambiental). Verifique se o modelo entrega só um número ou também discute estrutura de incentivos e efeitos sistêmicos. | Modelos com CoT mais longo tendem a estruturar melhor; CoT curto vira planilha. |
| 4 | **Superestimar racionalidade perfeita** — ignorar vieses comportamentais. | Prompt #3 com follow-up: *"considere viés de presente do operador da empresa"*. | O CoT mostra se o modelo *integra* o viés ou apenas o *menciona*. |
| 5 | **Aplicar conceitos fora de contexto** — mercado competitivo em ambiente monopolístico, etc. | Prompt #4 (Coase em contexto brasileiro). Verifique se o modelo aterra Coase no Judiciário lento brasileiro ou usa exemplo genérico. | Comparar DeepSeek R1 (raciocínio explícito sobre instituições) × Gemma (sem CoT, tende ao genérico). |
| 6 | **Desconsiderar custos institucionais** — solução teórica impraticável na realidade. | Prompt #4. O passo 2 exige listar custos de transação reais (custas, prazos, perícia). | CoT honesto admite *"não tenho dado preciso"*; CoT raso *chuta* valores convincentes. |
| 7 | **Não explicitar incerteza** — decisões raramente operam sob certeza plena. | Prompt #5 (Stress test) força o passo de incerteza. Sem ele, observe quantos modelos a omitem. | O CoT é o melhor termômetro de calibragem: hesitação no raciocínio que *desaparece* na resposta final é red flag. |
| 8 | **Aceitar respostas da IA sem teste crítico** — "erro especialmente relevante neste livro". | Botão **🔁 Stress test** em qualquer card (alimentado pelo Prompt 72 do ebook). | Compare CoT da resposta original com o da autocrítica: o modelo realmente desafia ou apenas reformula? |
| 9 | **Confundir eficiência com legitimidade normativa** — eficiente ≠ constitucional. | Prompt #4 com follow-up: *"essa solução é constitucional sob o art. 170?"* | CoT revela se o modelo *separa* análise consequencialista de análise dogmática ou as funde. |
| 10 | **Ignorar efeitos dinâmicos** — precedentes alteram incentivos futuros. | Prompt #3 (passo 4 cobra efeitos sistêmicos: prêmio de risco, custo de capital). | CoT que enumera efeitos de 2ª e 3ª ordem é o sinal de qualidade. |

### §1.2 — Os 5 erros específicos no uso de IA (cap. 19.3)

| # | Erro do ebook (literal) | Antídoto na plataforma | O que observar no CoT |
|---|--------------------------|------------------------|------------------------|
| 1 | **Prompt genérico demais** — gera resposta superficial. | Comparar `"fale sobre AED"` × Prompt #1 (Método 7 passos). | Prompt vago → CoT difuso, sem estrutura. Prompt estruturado → CoT segue os passos. |
| 2 | **Não solicitar mecanismo causal** — sem cadeia lógica explícita. | Prompt #1, passo 3 (mecanismo causal e teorias de dano). | CoT deve mostrar a cadeia *X → Y → Z*; resposta final sem CoT esconde se o modelo apenas pulou para a conclusão. |
| 3 | **Não pedir hipóteses alternativas** — risco de viés de confirmação. | Prompt #5 (Stress test) e botão 🔁 Stress test. | A "hipótese alternativa" do CoT precisa ser *substantiva*, não cosmética. |
| 4 | **Não classificar grau de confiança** — respostas devem explicitar incerteza. | Toggle 🛡️ (Prompt 23 de segurança) força o modelo a separar fato/inferência/sugestão. | CoT honesto admite lacunas; modelos sem CoT tendem a uniformizar tom de confiança. |
| 5 | **Usar IA para substituir leitura técnica** — IA organiza, não substitui domínio. | Reflexão de aula: nenhum prompt isoladamente cobre isso. Use o checklist final do cap. 19.4. | Quando o CoT mostra o modelo "inventando" doutrina, é sinal de que falta leitura humana. |

---

## §2. Falhas adicionais observadas na prática

A lista do ebook é necessária, mas insuficiente para o uso cotidiano de IA generativa em Direito brasileiro. Estes dez pontos complementam — não substituem — o cap. 19.

### §2.1 Jurisprudência brasileira inventada
Modelos alucinam números de acórdão, ementas, relatores, datas. Misturam STJ com STF, ou citam tribunais estrangeiros como se fossem brasileiros.
**Demo:** prompt ad-hoc *"cite 3 acórdãos do STJ aplicando explicitamente o Teorema de Coase"*. Compare com toggle 🛡️ ativado.
**Verificação:** sempre conferir número e relator no [STJ](https://www.stj.jus.br) ou [STF](https://www.stf.jus.br).

### §2.2 Dados quantitativos desatualizados
O cutoff de treinamento congela séries do IPEA, CNJ, BCB. Um modelo com cutoff de 2024 fala com confiança sobre o "Justiça em Números 2025" sem saber que mudou.
**Demo:** pedir tempo médio de tramitação do TJSP em 2025. Cruzar com [CNJ — Justiça em Números](https://www.cnj.jus.br/pesquisas-judiciarias/justica-em-numeros/) e [IPEADATA](http://www.ipeadata.gov.br).

### §2.3 Viés Chicago School / anglo-saxão
A literatura de treino sobre AED é majoritariamente Posner/Coase/Calabresi. Crítica heterodoxa (CLS, Bresser-Pereira, institucionalismo brasileiro, AED francesa) aparece subrepresentada.
**Liga-se ao erro 9 do ebook** (eficiência ≠ legitimidade).
**Demo:** prompt *"liste as 5 principais limitações teóricas da AED"* — mapeie quem é citado e quem é omitido.

### §2.4 Descontextualização Brasil
Aplicar Coase com custos de transação ≈ 0 é razoável em jurisdições com tribunais rápidos e baratos. No Brasil, é fantasia.
**Liga-se ao erro 5 do ebook** (aplicar conceitos fora de contexto).
**Demo:** Prompt #4. Observar quem cita custas reais do TJSP e prazos do CNJ vs. quem usa exemplo genérico de "duas fazendas".

### §2.5 Alucinação de autores e obras
Frases mal atribuídas a Posner, livros inexistentes de Calabresi, capítulos imaginários do *Economic Analysis of Law*.
**Demo:** *"Cite a frase exata de Posner sobre eficiência distributiva no capítulo X de Economic Analysis of Law"*. Verificar na obra original.

### §2.6 Raciocínio matemático raso sem CoT
Pareto, Kaldor-Hicks, p·S (probabilidade × severidade) com múltiplas variáveis costuma errar quando o modelo não pensa em voz alta. **Aqui o CoT é o instrumento pedagógico central** — expõe onde o modelo se perde.
**Demo:** Prompt #3 (Dano ambiental). Compare Gemma (sem CoT) × R1/o4-mini (com CoT). O erro aritmético típico vai mascarado por linguagem fluida quando o raciocínio não está exposto.

### §2.7 Geopolítica do modelo
DeepSeek (CN) × Claude/o4-mini (US) divergem em prompts sobre propriedade privada, intervenção estatal e críticas ao Estado.
**Demo:** Prompt #4 (Coase). Comparar a leitura de cada modelo sobre o papel do Judiciário e da regulação. Não é "viés ruim" — é informação sobre de onde vem o consenso textual de cada modelo.

### §2.8 Confusão entre doutrina e lei positivada
IAs tratam opinião de Posner como regra vinculante; inventam artigos do Código Civil; misturam súmula com posição majoritária.
**Complementa o erro 9 do ebook**.
**Demo:** *"qual o fundamento legal brasileiro para análise consequencialista de decisões?"* — verificar se cita LINDB art. 20 (real) ou inventa artigo.

### §2.9 Ilusão de profundidade em prompts vagos
Modelos preenchem espaço com generalidades convincentes. Texto longo ≠ análise robusta.
**Demo:** comparar resposta a *"fale sobre AED em contratos"* (vago) × Prompt #2 (estruturado). Mesmo modelo, qualidade radicalmente diferente.

### §2.10 Falsa calibragem de incerteza
Modelos tendem a excesso de confiança mesmo quando não sabem. O Prompt 72 (Stress test) e o Prompt 23 (Segurança) do ebook são os antídotos.
**Complementa o erro 4 do ebook**.
**Demo:** Pedir uma estimativa quantitativa qualquer e observar se o modelo declara faixa de confiança espontaneamente.

---

## §3. Roadmap de melhorias da plataforma

### §3.1 Técnicas

- **Prompt caching (Anthropic)** — corta custo em prompts repetidos. O ebook usa sempre os mesmos Prompt 23/74; cache reduz custo de tokens de prefixo em ~90%.
- **Streaming SSE** — exibir resposta incrementalmente, mais engajante em sala.
- **Exportação de relatório PDF pós-aula** — consolidar prompts, respostas e CoT por sessão para distribuição aos alunos.
- **Hash do prompt-texto** — chave de correlação cross-session, permite agregar respostas ao mesmo prompt mesmo entre aulas.
- **Mais views no Supabase** — divergência cross-modelo, ranking de eixos mais usados, série temporal de custo por aula.

### §3.2 Pedagógicas

- **Rubrica de avaliação** — após cada resposta, aluno marca 4 checkboxes:
  1. Precisão jurídica (cita lei/precedente real?)
  2. Profundidade AED (cobre os 7 passos?)
  3. Alucinação (sim/não)
  4. Aderência ao método

  Persistido em nova tabela `response_ratings`. Permite construir, ao longo do semestre, um ranking de modelos *na percepção da turma* — e comparar com custo, latência e CoT.

- **Duelo cego** — alunos votam na melhor resposta sem saber qual modelo respondeu. Combate o viés de marca ("Claude é melhor porque é caro").

- **Dashboard de discordância** — onde modelos mais divergem = onde a AED é mais contestada teoricamente. Visualização útil para o professor identificar os pontos quentes do conteúdo.

- **Modo "comparação dirigida"** — selecionar apenas 2 modelos (ex.: Gemma × R1) para isolar o efeito do CoT. Hoje a plataforma sempre dispara os 5.

### §3.3 Segurança

- **Extrair `OPENROUTER_KEY` do `config.js` versionado** — hoje a chave fica em repo (mesmo que com `.gitignore`, basta um descuido). Caminhos:
  1. Variável de ambiente injetada em build-time (precisa de bundler — quebra o "single file").
  2. **Proxy backend via Supabase Edge Function** — chama OpenRouter server-side, guarda a chave no Supabase Vault. Mantém o front-end estático e a chave nunca trafega ao cliente.

  **Não bloqueia o pedido atual**, mas é a próxima dívida técnica importante. O comentário em [config.js](../config.js) mitigando o problema (gerar key nova por aula, limite de gasto) é um workaround pedagógico, não uma solução de segurança.

- **Sanitização de PII em prompts** — antes do envio à OpenRouter, regex local removendo CPF, CNPJ, e-mails. Reforça o que o toggle 🛡️ pede ao modelo, mas como camada de defesa do lado cliente.

- **RLS por sessão** — hoje qualquer sessão lê qualquer prompt. Restringir leitura por `session_id` ou por `student_id` evita que aluno veja resposta de colega antes de submeter a sua (importante para exercícios avaliativos).

---

## §4. Como usar este documento

- **Antes da aula:** professor escolhe 1–2 erros do §1 ou §2 que serão demonstrados.
- **Durante a aula:** aluno roda o prompt indicado, com o toggle apropriado, e o professor pede que o aluno *aponte no CoT* o sinal do erro antes de olhar a resposta final.
- **Depois da aula:** aluno consulta `full_history` no Supabase, exporta CSV/JSON, e usa o §3 do checklist (cap. 19.4 do ebook) para validar a própria análise.

O ponto não é que a IA esteja errada — é que ela está confiantemente errada com a mesma fluência com que está confiantemente certa. O método AED, exposto pelo CoT, é o que permite ao operador do Direito distinguir um caso do outro.
