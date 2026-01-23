# Output-First Thinking: Templating pro Agenticky Coding

> Skolici material pro developersky tym aktivne vyuzivajici Claude Code

---

## Proc Templating?

LLM jsou **nedeterministicke**. To samo o sobe neni problem.

Problem je, ze **nespecifikujeme co chceme dostat zpet**.

```
┌─────────────────────────────────────────────────────────────┐
│  "Pridej autentizaci"                                       │
│                                                             │
│  Agent neví:                                                │
│  • Ma vratit kod? Plan? Otazky?                             │
│  • V jakem formatu?                                         │
│  • Co s tim vystupem udelam ja? Co dalsi agent?             │
│  • Je vystup "hotovy" nebo "k review"?                      │
└─────────────────────────────────────────────────────────────┘
```

**Klicova otazka**: Kdyz agent skonci, vim presne co dostanu a co s tim udelam dal?

**Reseni**: Templating — predefinovane vzory pro vstupy a vystupy, ktere zajisti konzistentni chovani.

---

## Vizualni Schema: Retezeni Promptu

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                        AGENTICKY WORKFLOW PIPELINE                               │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│   ┌────────────┐    ┌────────────┐    ┌────────────┐    ┌────────────┐         │
│   │   VSTUP    │    │   PLAN     │    │  EXECUTE   │    │   VYSTUP   │         │
│   │            │    │            │    │            │    │            │         │
│   │  Feature   │───►│  /feature  │───►│ /implement │───►│   Commit   │         │
│   │  Bug       │    │  /bug      │    │            │    │   PR       │         │
│   │  Chore     │    │  /chore    │    │            │    │   Review   │         │
│   └────────────┘    └────────────┘    └────────────┘    └────────────┘         │
│        │                  │                  │                  │               │
│        ▼                  ▼                  ▼                  ▼               │
│   ┌────────────┐    ┌────────────┐    ┌────────────┐    ┌────────────┐         │
│   │ TEMPLATE   │    │ TEMPLATE   │    │ TEMPLATE   │    │ TEMPLATE   │         │
│   │            │    │            │    │            │    │            │         │
│   │ Backlog ID │    │ Plan File  │    │ Impl File  │    │ Report     │         │
│   │ Folder     │    │ Strukturov │    │ Step-by-   │    │ JSON/MD    │         │
│   │ Popis      │    │ any JSON   │    │ step akce  │    │ parseable  │         │
│   └────────────┘    └────────────┘    └────────────┘    └────────────┘         │
│                                                                                  │
│   KAZDY KROK MA DEFINOVANY VSTUP A VYSTUP = KONTRAKT                           │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### Jak To Funguje

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                                                                  │
│  1. ZADAVATEL (PO/SM/Dev) vytvoří standardizovaný vstup:                        │
│                                                                                  │
│     specs/                                                                       │
│     └── BACKLOG-123-user-login/                                                  │
│         ├── requirements.md      ← Co ma byt vysledek                           │
│         └── constraints.yaml     ← Technicke omezeni                            │
│                                                                                  │
│  2. PLANOVACI AGENT (/feature, /bug, /chore) cte vstup a generuje:             │
│                                                                                  │
│     specs/BACKLOG-123-user-login/                                               │
│     └── plan.md                  ← Strukturovany plan implementace              │
│                                                                                  │
│  3. IMPLEMENTACNI AGENT (/implement) cte plan a generuje:                       │
│                                                                                  │
│     specs/BACKLOG-123-user-login/                                               │
│     └── implementation.md        ← Krok-po-kroku instrukce                      │
│                                                                                  │
│  4. EXECUTION AGENT provede implementation.md a reportuje:                      │
│                                                                                  │
│     specs/BACKLOG-123-user-login/                                               │
│     └── report.json              ← Vysledek (success/failure + details)         │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Dva Typy Vystupu

Kazdy vystup agenta patri do jedne z techto kategorii:

```
┌─────────────────────────────────────────────────────────────┐
│  TYP A: Vystup Pro Cloveka                                  │
│  ─────────────────────────                                  │
│  • Vyzaduje lidsky usudek                                   │
│  • Format: citelny, volnejsi                                │
│  • Priklad: "Navrhuji 3 pristupy k reseni..."               │
│  • Dalsi krok: Clovek rozhodne                              │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  TYP B: Vystup Pro Agenta                                   │
│  ────────────────────────                                   │
│  • Muze byt zpracovan automaticky                           │
│  • Format: strukturovany, parseovatelny                     │
│  • Priklad: {"status": "success", "file": "specs/..."}      │
│  • Dalsi krok: Dalsi agent pokracuje                        │
└─────────────────────────────────────────────────────────────┘
```

**Pravidlo**: Pokud nevite ktery typ, vase specifikace neni dostatecna.

---

## Proc Templating Umoznuje Out-of-Loop Execution

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                                                                  │
│   BEZ TEMPLATINGU:                                                              │
│   ────────────────                                                              │
│                                                                                  │
│   Developer ──► prompt ──► Agent ──► ? ──► Developer musi zkontrolovat          │
│                                      │                                          │
│                                      └── Vystup neni predvidatelny              │
│                                      └── Format se meni                         │
│                                      └── Dalsi agent nevie co cekat             │
│                                                                                  │
│   = CLOVEK VZDY V LOOPU                                                         │
│                                                                                  │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│   S TEMPLATINGEM:                                                               │
│   ───────────────                                                               │
│                                                                                  │
│   Template ──► Agent A ──► Definovany vystup ──► Agent B ──► ...               │
│      │              │              │                  │                         │
│      │              │              │                  │                         │
│      ▼              ▼              ▼                  ▼                         │
│   Vstup je      Chovani je     Vystup je         Vstup je                      │
│   jasny         omezene        parseovatelny     ocekavany                     │
│                                                                                  │
│   = AGENTI MOHOU RETEZIT BEZ LIDSKE INTERVENCE                                 │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Anatomie Agenticky Zpracovatelneho Vystupu

### Co Dela Vystup "Agenticky Bezpecny"

```
┌─────────────────────────────────────────────────────────────┐
│  AGENTICKY ZPRACOVATELNY VYSTUP                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. PARSEOVATELNOST                                         │
│     └── JSON.parse() musi fungovat VZDY                     │
│     └── Zadny text pred/za strukturou                       │
│     └── Zadne "tady je vystup:" uvody                       │
│                                                             │
│  2. PREDVIDATELNA STRUKTURA                                 │
│     └── Stejne klice pri kazdem behu                        │
│     └── Typy hodnot jsou konzistentni                       │
│     └── Dalsi agent vi kam sahnout pro data                 │
│                                                             │
│  3. KOMPLETNOST                                             │
│     └── Obsahuje vse co dalsi agent potrebuje               │
│     └── Zadne implicitni predpoklady                        │
│     └── Self-contained - neni treba "domyslet"              │
│                                                             │
│  4. VALIDOVATELNOST                                         │
│     └── success/failure je explicitni                       │
│     └── Errors jsou strukturovane, ne prose                 │
│     └── Lze programaticky rozhodnout dalsi krok             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Priklad: Test Output

```json
// SPATNE - agent nevi co s tim
"Testy probehly, 3 prosly, 1 selhal na radku 42"

// DOBRE - agent presne vi co delat dal
{
  "passed": false,
  "tests": [
    {"name": "syntax_check", "passed": true},
    {"name": "type_check", "passed": false,
     "error": "TS2345 line 42",
     "file": "src/auth.ts"}
  ],
  "next_action": "fix_errors"
}
```

**Rozdil**: Druhy format umoznuje dalsimu agentovi automaticky:
- Vedet ze neco selhalo (`passed: false`)
- Najit presne kde (`file`, `error`)
- Rozhodnout co dal (`next_action`)

---

## Tri Urovne Vedomí Agenta

```
┌─────────────────────────────────────────────────────────────┐
│  UROVEN 1: Vedomí Ukolu                                     │
│  ─────────────────────                                      │
│  Agent vi CO ma udelat                                      │
│  "Proved testy na backendu"                                 │
│                                                             │
│  Problem: Nevi JAK ma vysledek predat dal                   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  UROVEN 2: Vedomí Vystupu                                   │
│  ────────────────────────                                   │
│  Agent vi CO ma udelat + JAKY VYSTUP vratit                 │
│  "Proved testy, vrat JSON array s vysledky"                 │
│                                                             │
│  Problem: Nevi KDO vystup spotrebuje a PROC                 │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  UROVEN 3: Vedomí Kontextu (CIL)                            │
│  ───────────────────────────────                            │
│  Agent vi:                                                  │
│  • CO ma udelat                                             │
│  • JAKY VYSTUP vratit                                       │
│  • KDO vystup pouzije (clovek/agent)                        │
│  • CO se s vystupem stane dal                               │
│  • JAK pozna uspech/neuspech                                │
│                                                             │
│  "Proved testy. Vrat JSON array. Pokud vsechny passed=true, │
│   dalsi agent spusti /review. Pokud ne, /resolve_failed."   │
└─────────────────────────────────────────────────────────────┘
```

### Jak Dostat Agenta na Uroven 3

V kazdem promptu/commandu explicitne uvest:

```markdown
## Report

- IMPORTANT: Return ONLY the JSON array
- We'll immediately run JSON.parse() on output
- If all tests pass → next agent runs /review
- If any test fails → next agent runs /resolve_failed_test
- Do not include explanations, only the structure
```

---

## Princip Kontraktu Mezi Agenty

```
┌──────────────┐     kontrakt      ┌──────────────┐
│   Agent A    │ ───────────────► │   Agent B    │
│              │                   │              │
│ Output:      │                   │ Input:       │
│ {            │   MUSI MATCHOVAT  │ ocekava {    │
│   file: str  │ ◄───────────────► │   file: str  │
│   status: x  │                   │   status: x  │
│ }            │                   │ }            │
└──────────────┘                   └──────────────┘
```

### Realny Chain: Feature → Implement → Test

```
/feature
├── Input: issue_json (z GitHub)
├── Output: { plan_path: "specs/issue-123-*.md" }
└── Kontrakt: Vraci CESTU k souboru, ne obsah

        ▼

/implement
├── Input: plan_path (z /feature)
├── Akce: Precte soubor na plan_path, implementuje
├── Output: { files_changed: [...], diff_stats: "..." }
└── Kontrakt: Vraci SEZNAM zmenenych souboru

        ▼

/test
├── Input: (implicitne aktualni stav kodu)
├── Akce: Spusti validacni testy
├── Output: [{ test_name, passed, error? }, ...]
└── Kontrakt: Vraci ARRAY s vysledky, failed testy PRVNI

        ▼

BRANCH LOGIC (automaticky):
├── Vsechny passed=true → /review
└── Nektery passed=false → /resolve_failed_test
```

**Klicove**: Zadny clovek v loopu. Kontrakty umoznuji automaticke rozhodovani.

---

## Out-of-Loop Readiness Checklist

Pred tim nez recete "toto muze bezet bez me":

```
□ PARSEOVATELNOST
  └── Vystup projde JSON.parse() / YAML.parse() vzdy?
  └── Zadny okolni text ktery by to rozbil?

□ BRANCH LOGIC
  └── Je jasne definovano co se deje pri uspechu?
  └── Je jasne definovano co se deje pri neuspechu?
  └── Jsou vsechny edge cases pokryty?

□ ERROR HANDLING
  └── Kdyz agent selze, je error strukturovany?
  └── Obsahuje error dost info pro dalsi pokus/fix?

□ IDEMPOTENCE
  └── Muze se tento krok opakovat bez poskozeni?
  └── Nebo je potreba cleanup pred opakovanim?

□ VALIDATION
  └── Existuje zpusob jak overit ze vystup je "spravny"?
  └── Jsou definovany acceptance criteria?
```

---

## Sablona Pro "Output-First" Command

```markdown
# [Command Name]

[Co tento command dela - 1 veta]

## Context Awareness

Tento vystup bude pouzit:
- [ ] Clovekem pro rozhodnuti
- [ ] Dalsim agentem pro [konkretni akce]
- [ ] Jako vstup do [jmeno dalsiho commandu]

## Instructions

[Kroky co agent ma delat]

## Output Contract

```json
{
  "required_field": "type - popis",
  "status": "'success' | 'failure'",
  "next_action": "string - co se ma stat dal"
}
```

IMPORTANT:
- Return ONLY this JSON structure
- No text before or after
- Consumer: [kdo/co to parsne]

## Branch Logic

- If status="success" → [co se stane]
- If status="failure" → [co se stane]

## Validation

Vystup je validni kdyz:
- [ ] JSON.parse() uspeje
- [ ] required_field neni null
- [ ] [dalsi kriteria]
```

---

## Evoluce Tymu

### Faze 1: Individual Awareness

Kazdy clen tymu:
- Rozumi rozdilu mezi "vystup pro cloveka" a "vystup pro agenta"
- Umi napsat command s jasnym Output Contract
- Testuje ze vystup je parseovatelny a konzistentni

### Faze 2: Teamwork Patterns

Tym jako celek:
- Ma definovane kontrakty mezi agenty (feature→implement→test)
- Kazdy vi co jeho vystup "otevre" pro dalsiho
- Dokumentuje branch logic pro kazdy node

### Faze 3: Autonomous Pipelines

Cely system:
- GitHub issue spusti chain bez lidske intervence
- Lide vstupuji pouze pri blocker issues
- Observability umoznuje post-hoc audit

---

## Zaver

> **Agentic Coding neni o tom psat lepsi prompty.
> Je to o tom presne vedet jaky vystup potrebujete
> a kdo/co ten vystup spotrebuje dal.**

Kdyz toto vite, agenti mohou pracovat sami.
Kdyz toto nevite, budete navzdy v loopu.

---

## Quick Reference

### Output Types

| Typ | Format | Konzument | Priklad |
|-----|--------|-----------|---------|
| Human-readable | Prose, markdown | Developer | Code review komentare |
| Agent-parseable | JSON, structured | Dalsi agent | Test results |
| Hybrid | JSON + summary | Oba | PR description |

### Branch Logic Keywords

| Keyword v Output | Vyznam |
|------------------|--------|
| `"success": true` | Pokracuj na dalsi krok |
| `"success": false` | Spust error handling |
| `"blocker": true` | STOP - vyzaduje lidsky zasah |
| `"next_action": "X"` | Explicitne rici co dal |

### Validation Checklist

```
□ JSON.parse() funguje?
□ Vsechny required fields pritomny?
□ Typy hodnot odpovidaji kontraktu?
□ Branch logic pokryva vsechny stavy?
□ Error messages jsou actionable?
```

---

## Souvisejici Materialy

- [02-commands](../lessons/foundations/02-commands.md) — Zaklady slash commandu
- [03-skills](../lessons/foundations/03-skills.md) — Stavba reusable skills
- [07-subagents](../lessons/context-management/07-subagents.md) — Delegace na specialisty
- [08-forked-context](../lessons/context-management/08-forked-context.md) — Izolace kontextu

---

*Output-First Thinking | Agentic Engineer Playbook | 2026*
