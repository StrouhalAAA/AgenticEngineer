# Claude Code Status Line - Konfigurace pro tým

## Obsah
1. [Co je Status Line](#co-je-status-line)
2. [Status Line vs Hooks - Rozdíl](#status-line-vs-hooks---rozdíl)
3. [Struktura souborů](#struktura-souborů)
4. [Rychlý start](#rychlý-start)
5. [Vytvoření vlastního status line skriptu](#vytvoření-vlastního-status-line-skriptu)
6. [Konfigurace v settings.local.json](#konfigurace-v-settingslocaljson)
7. [Dostupné metriky z JSON vstupu](#dostupné-metriky-z-json-vstupu)
8. [Příklady konfigurace](#příklady-konfigurace)
9. [Troubleshooting](#troubleshooting)

---

## Co je Status Line

Status Line je customizovatelná informační lišta v Claude Code, která zobrazuje relevantní metriky během práce. Může zobrazovat:
- Aktuální model (Opus, Sonnet, Haiku)
- Využití kontextového okna (%)
- Počet tokenů (input/output)
- Git branch a změny
- Délku session
- Přidané/odebrané řádky kódu
- A cokoliv dalšího, co si nakonfigurujete

**Ukázka výstupu:**
```
🌿 main ±3 | 🟢 42% | 📝 15k→8k | ⏱ 23m | +156/-23 | 🤖 Opus4.5
```

---

## Status Line vs Hooks - Rozdíl

**Důležité:** `statusLine` a `hooks` jsou **dvě samostatné a nezávislé** konfigurace v Claude Code. Často se objevují společně v `settings.local.json`, ale fungují úplně odlišně.

### Struktura v settings.json

```json
{
  "statusLine": {        // ← SAMOSTATNÁ sekce pro status line
    "type": "command",
    "command": "./.claude/_status_line_JST.sh"
  },
  "hooks": {             // ← SAMOSTATNÁ sekce pro hooks
    "SessionStart": [...]
  },
  "permissions": {       // ← SAMOSTATNÁ sekce pro permissions
    "allow": [...]
  }
}
```

### Srovnání

| Vlastnost | Status Line | Hooks |
|-----------|-------------|-------|
| **Účel** | Zobrazuje informace v UI (dolní lišta) | Spouští akce při specifických událostech |
| **Kdy běží** | Průběžně (periodický refresh) | Jednorázově při události |
| **Výstup** | Text zobrazený uživateli | Může být skrytý, logovaný, nebo žádný |
| **Vstup** | JSON s metrikami session | Závisí na typu hooku |
| **Příklad použití** | Zobrazit git branch, využití kontextu | Inicializovat session, logovat příkazy |

### Typy Hooks (pro kontext)

| Hook | Kdy se spustí |
|------|---------------|
| `SessionStart` | Na začátku nové session |
| `SessionEnd` | Na konci session |
| `PreToolUse` | Před použitím nástroje (Bash, Read, Edit...) |
| `PostToolUse` | Po použití nástroje |

### Proč jsou obě v settings.local.json?

Obě konfigurace patří do **osobního nastavení** (`settings.local.json`), protože:

1. **Status Line** - každý vývojář preferuje jiné metriky a formát zobrazení
2. **Hooks** - osobní automatizace (logování, tracking, inicializace prostředí)

**Ani jedno nepatří do týmového `settings.json`** - jsou to osobní preference, ne projektová pravidla.

---

## Struktura souborů

```
.claude/
├── settings.json           # Týmová konfigurace (VERZOVANÁ)
├── settings.local.json     # Osobní konfigurace (GIT-IGNOROVANÁ)
├── _status_line_JST.sh     # Ukázkový minimalistický skript (GIT-IGNOROVANÝ)
├── commands/
│   └── jpi-status.sh       # Ukázkový pokročilý skript
└── docs/
    └── Status_Line_Configuration_Guide.md  # Tato dokumentace
```

### Konvence pojmenování
- **`_*.sh`** - Osobní skripty (prefix `_` = git-ignorované)
- **`*-status.sh`** - Sdílené/ukázkové skripty

---

## Rychlý start

### Krok 1: Vytvořte lokální konfiguraci

Vytvořte soubor `.claude/settings.local.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "./.claude/_status_line_VASE_INICIALY.sh"
  }
}
```

**Poznámka:** Soubor `settings.local.json` je v `.gitignore` - vaše osobní nastavení se nepropaguje do repozitáře.

### Krok 2: Vytvořte svůj status line skript

Zkopírujte ukázkový skript a upravte si ho:

```bash
cp .claude/_status_line_JST.sh .claude/_status_line_VASE_INICIALY.sh
```

### Krok 3: Nastavte práva

```bash
chmod +x .claude/_status_line_VASE_INICIALY.sh
```

### Krok 4: Restartujte Claude Code

Nová konfigurace se načte po restartu.

---

## Vytvoření vlastního status line skriptu

### Základní šablona

```bash
#!/bin/bash

# Minimální status line skript
# Čte JSON vstup ze stdin a zobrazuje metriky

input=$(cat)

# Model name (zkrácený)
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
case "$(echo "$MODEL" | tr '[:upper:]' '[:lower:]')" in
    *opus-4-5*) MODEL_SHORT="Opus4.5" ;;
    *opus-4-1*) MODEL_SHORT="Opus4.1" ;;
    *sonnet-4*) MODEL_SHORT="Sonnet4" ;;
    *sonnet*) MODEL_SHORT="Sonnet" ;;
    *haiku*) MODEL_SHORT="Haiku" ;;
    *) MODEL_SHORT="$MODEL" ;;
esac

# Context usage s barevným indikátorem
USED_PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
if [ "$USED_PCT" -gt 80 ]; then
    CTX_ICON="🔴"  # Kritické
elif [ "$USED_PCT" -gt 60 ]; then
    CTX_ICON="🟡"  # Varování
else
    CTX_ICON="🟢"  # OK
fi

# Git branch
GIT_BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    GIT_BRANCH=$(git branch --show-current 2>/dev/null || echo "detached")
fi

# Výstup
echo "🌿 ${GIT_BRANCH} | ${CTX_ICON} ${USED_PCT}% | 🤖 ${MODEL_SHORT}"
```

### Jak to funguje

1. Claude Code volá váš skript a **posílá JSON na stdin**
2. Skript parsuje JSON pomocí `jq`
3. Skript vypisuje výstup na stdout
4. Claude Code zobrazuje výstup jako status line

---

## Konfigurace v settings.local.json

### Minimální konfigurace

```json
{
  "statusLine": {
    "type": "command",
    "command": "./.claude/_status_line_JST.sh"
  }
}
```

### Rozšířená konfigurace (statusLine + hooks + permissions)

Tento příklad ukazuje kompletní `settings.local.json` se všemi třemi sekcemi. **Každá sekce je nezávislá** - můžete použít pouze `statusLine` bez hooks, nebo naopak.

```json
{
  "statusLine": {                          // SEKCE 1: Status line (volitelná)
    "type": "command",
    "command": "./.claude/_status_line_JST.sh"
  },
  "hooks": {                               // SEKCE 2: Hooks (volitelná, nezávislá na statusLine)
    "SessionStart": [
      {
        "matcher": { "always": true },
        "hooks": [
          {
            "type": "command",
            "command": "./.claude/hooks/my-session-init.sh"
          }
        ]
      }
    ]
  },
  "permissions": {                         // SEKCE 3: Permissions (volitelná)
    "allow": [
      "Bash(curl:*)",
      "Bash(sqlcmd:*)"
    ]
  }
}
```

### Statický text (jednodušší varianta)

```json
{
  "statusLine": {
    "type": "static",
    "text": "ACBS Project | Ready"
  }
}
```

---

## Dostupné metriky z JSON vstupu

Claude Code posílá do skriptu JSON s těmito daty:

| Cesta | Popis | Příklad |
|-------|-------|---------|
| `.model.display_name` | Název modelu | `"claude-opus-4-5-20251101"` |
| `.context_window.used_percentage` | Využití kontextu | `42.5` |
| `.context_window.total_input_tokens` | Celkem input tokenů | `15000` |
| `.context_window.total_output_tokens` | Celkem output tokenů | `8000` |
| `.cost.total_duration_ms` | Délka session v ms | `1380000` |
| `.cost.total_lines_added` | Přidané řádky | `156` |
| `.cost.total_lines_removed` | Odebrané řádky | `23` |

### Příklad parsování v bash

```bash
input=$(cat)

# Všechny dostupné metriky
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
USED_PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
INPUT_TOKENS=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
OUTPUT_TOKENS=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
LINES_ADDED=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
LINES_REMOVED=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
```

---

## Příklady konfigurace

### Minimalistický (doporučeno)

Soubor: `.claude/_status_line_MIN.sh`

```bash
#!/bin/bash
input=$(cat)
MODEL=$(echo "$input" | jq -r '.model.display_name // "?"' | sed 's/claude-//' | cut -c1-6)
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
BRANCH=$(git branch --show-current 2>/dev/null || echo "?")
echo "🌿 $BRANCH | $PCT% | $MODEL"
```

### Pokročilý s progress barem

Soubor: `.claude/_status_line_ADV.sh`

```bash
#!/bin/bash
input=$(cat)

# Metriky
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
DURATION_MIN=$((DURATION_MS / 60000))

# Progress bar
FILLED=$((PCT / 10))
BAR=""
for ((i=1; i<=FILLED; i++)); do BAR+="█"; done
for ((i=FILLED+1; i<=10; i++)); do BAR+="░"; done

# Git info
BRANCH=$(git branch --show-current 2>/dev/null || echo "?")
CHANGES=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')

echo "🌿 $BRANCH ±$CHANGES | [$BAR] $PCT% | ⏱ ${DURATION_MIN}m | 🤖 $MODEL"
```

### Multi-line výstup

```bash
#!/bin/bash
input=$(cat)

# Řádek 1: Git a model
echo "🌿 $(git branch --show-current) | 🤖 $(echo "$input" | jq -r '.model.display_name' | sed 's/claude-//')"

# Řádek 2: Metriky
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
ADDED=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
REMOVED=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
echo "📊 Context: ${PCT}% | Lines: +${ADDED}/-${REMOVED}"
```

---

## Troubleshooting

### Status line se nezobrazuje

1. **Zkontrolujte syntaxi JSON:**
   ```bash
   jq empty .claude/settings.local.json
   ```

2. **Ověřte že skript je executable:**
   ```bash
   ls -la .claude/_status_line_*.sh
   # Mělo by být: -rwxr-xr-x
   ```

3. **Otestujte skript ručně:**
   ```bash
   echo '{"model":{"display_name":"opus"}}' | ./.claude/_status_line_JST.sh
   ```

4. **Restartujte Claude Code**

### Skript nefunguje

1. **Zkontrolujte jq:**
   ```bash
   which jq
   # Pokud není nainstalovaný: brew install jq (macOS) / apt install jq (Linux)
   ```

2. **Debug výstup:**
   ```bash
   # Přidejte na začátek skriptu:
   echo "$input" > /tmp/claude_status_debug.json
   ```

### Git informace se nezobrazují

Ujistěte se, že spouštíte Claude Code z git repozitáře:
```bash
git rev-parse --show-toplevel
# Mělo by vrátit cestu k ACBS
```

---

## Best Practices

1. **Používejte prefix `_`** pro osobní skripty - jsou automaticky git-ignorované
2. **Testujte offline** - skript musí fungovat i bez připojení
3. **Nepoužívejte hardcoded cesty** - vždy detekujte root pomocí `git rev-parse`
4. **Držte výstup krátký** - ideálně 1-2 řádky, max 80 znaků na řádek
5. **Používejte emoji rozumně** - pro vizuální orientaci, ne dekoraci

---

## Related

- [Status Line Lesson (English)](../../lessons/configuration/04c-statusline.md)
- [Hooks Reference](../hooks/examples.md)
- [Settings Permissions](./permissions.md)

---

**Autor:** Claude AI
**Poslední aktualizace:** 2026-01-17
