# Claude Code - Kompletni zkratky a tahak

Claude Code nabizi v prikazove radce **80+ flagu**, **30+ lomenych prikazu** a **60+ promennych prostredi** pro prizpusobeni kazdeho aspektu chovani. Tato komplexni reference pokryva vse od zakladnich klavesovych zkratek po pokrocile automatizacni vzory - umoznuje vyvojarum maximalizovat produktivitu pri interaktivni praci, skriptovani pipeline nebo integraci s CI/CD systemy.

---

## 🎯 TOP 15: Nejdulezitejsi zkratky pro vyvojare

Tato sekce obsahuje **nejcasteji pouzivane** zkratky a flagy s praktickymi priklady pro frontend i backend vyvojare.

### CLI flagy - TOP 10

| # | Flag | Popis | Kdy pouzit |
|---|------|-------|------------|
| 1 | `-p` | Headless rezim | Automatizace, CI/CD, skripty |
| 2 | `-c` | Pokracovat v posledni session | Navazani na vcereji praci |
| 3 | `-r <id>` | Obnovit konkretni session | Prepinani mezi projekty |
| 4 | `--append-system-prompt` | Pridat kontext | Tymove standardy, projektova pravidla |
| 5 | `--model` | Vyber modelu | Opus pro slozite, Haiku pro rychle |
| 6 | `--output-format json` | JSON vystup | Parsovani v CI/CD |
| 7 | `--allowedTools` | Automaticky povolit nastroje | Duveryhodne operace bez potvrzeni |
| 8 | `--max-turns` | Limit iteraci | Kontrola nakladu |
| 9 | `--debug` | Debug logovani | Troubleshooting MCP/API |
| 10 | `--add-dir` | Vice adresaru | Monorepo projekty |

### Lomene prikazy - TOP 10

| # | Prikaz | Popis | Kdy pouzit |
|---|--------|-------|------------|
| 1 | `/clear` | Vycistit historii | Zacit novou ulohu |
| 2 | `/resume` | Obnovit session | Prepnout kontext |
| 3 | `/context` | Zobrazit vyuziti | Monitorovat tokeny |
| 4 | `/compact` | Zkomprimovat | Setrit kontext |
| 5 | `/model` | Zmenit model | Prepnout Opus/Sonnet |
| 6 | `/cost` | Statistiky | Sledovat naklady |
| 7 | `/plan` | Rezim planovani | Review pred zmenami |
| 8 | `/memory` | Editovat CLAUDE.md | Ucit Claude pravidla |
| 9 | `/init` | Inicializovat projekt | Novy projekt |
| 10 | `/export` | Exportovat konverzaci | Ulozit rozhodnuti |

### Klavesove zkratky - TOP 10

| # | Zkratka | Akce | Kdy pouzit |
|---|---------|------|------------|
| 1 | `Esc` | Zastavit generovani | Kdyz Claude jde spatnym smerem |
| 2 | `Esc+Esc` | Rewind menu | Vratit zmeny zpet |
| 3 | `Ctrl+C` | Zrusit vstup | Prepsat prompt |
| 4 | `Shift+Tab` | Prepnout rezim opravneni | Auto-accept/Plan mode |
| 5 | `Ctrl+B` | Pozadi | Dlouhe operace na pozadi |
| 6 | `Tab` | Rozsirene premysleni | Slozite problemy |
| 7 | `\` + Enter | Viceriadkovy vstup | Delsi prompty |
| 8 | `@soubor` | Reference souboru | Rychly kontext |
| 9 | `!prikaz` | Bash rezim | Spustit prikaz primo |
| 10 | `#poznamka` | Pridat do pameti | Ulozit do CLAUDE.md |

---

## 🖥️ Priklady pro Frontend vyvojare (Vue 3)

> **Tech stack:** Vue 3 + Composition API, Pinia, Vite, Vitest

### Denni workflow

```bash
# Rano - navazat na vcereji praci
claude -c

# Review Vue komponenty pro pristupnost
claude -p --append-system-prompt "Dodrzuj WCAG 2.1 AA standardy" \
  "Zkontroluj pristupnost @src/components/BaseButton.vue"

# Automaticka oprava ESLint chyb
claude -p --allowedTools "Write,Bash(npm run lint:*)" \
  "Oprav vsechny ESLint chyby v projektu"

# Generovat testy pro komponentu
claude "Napis unit testy pro @src/components/BaseModal.vue pouzij Vitest a Vue Test Utils"
```

### Typicke scenare

| Uloha | Doporuceny prikaz |
|-------|-------------------|
| **Debug stavu** | `claude "Vysvetli data flow v @src/stores/auth.ts"` (Pinia store) |
| **CSS problem** | `claude -p "Proc se tento grid rozbiji na mobilu? @src/styles/grid.css"` |
| **Refaktoring** | `claude --model opus "Refaktoruj na Composition API @src/components/UserForm.vue"` |
| **Code review** | `claude -p --append-system-prompt "Zamer se na Vue 3 best practices a a11y" @src/` |
| **Bundle size** | `cat stats.html \| claude -p "Analyzuj Vite bundle a najdi zbytecne velke zavislosti"` |
| **API composable** | `claude "Vytvor composable useUsers pro @src/api/users.ts s Vue Query"` |
| **Pinia store** | `claude "Vytvor Pinia store pro sprava uzivatelu podle @src/types/user.ts"` |

### Doporucene nastaveni v settings.json

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run lint:*)",
      "Bash(npm run test:*)",
      "Bash(npm run build)",
      "Bash(npx vitest:*)"
    ]
  },
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{ "type": "command", "command": "npx prettier --write $file" }]
    }]
  }
}
```

---

## ⚙️ Priklady pro Backend vyvojare (.NET)

> **Tech stack:** .NET 8, ASP.NET Core Web API, Entity Framework Core, SQL Server

### Denni workflow

```bash
# Analyza API logu
cat logs/api.log | claude -p "Identifikuj pomale endpointy a navrhni optimalizace"

# Debug s limitem nakladu
claude -p --max-turns 5 --max-budget-usd 2.00 \
  "Najdi memory leak v @src/Services/CacheService.cs"

# EF Core migrace review
claude --model opus "Zkontroluj bezpecnost teto migrace @Migrations/20240115_AddUsers.cs"

# Generovat API dokumentaci
claude -p --output-format json \
  "Vygeneruj OpenAPI spec pro @Controllers/UsersController.cs"
```

### Typicke scenare

| Uloha | Doporuceny prikaz |
|-------|-------------------|
| **API error** | `cat error.log \| claude -p "Vysvetli tuto .NET exception a navrhni opravu"` |
| **Performance** | `claude "Optimalizuj LINQ dotaz v @Repositories/OrderRepository.cs"` |
| **Security audit** | `claude -p --model opus "Bezpecnostni audit @Controllers/ a @Services/Auth/"` |
| **Microservices** | `claude --add-dir ../ServiceA ../ServiceB "Jak spolu komunikuji pres HTTP/gRPC?"` |
| **Docker debug** | `docker logs app | claude -p "Co zpusobuje restart .NET kontejneru?"` |
| **Test coverage** | `claude "Pridej xUnit integracni testy pro @Services/PaymentService.cs"` |
| **EF migration** | `claude "Vytvor EF Core migraci pro pridani tabulky Invoices"` |
| **Middleware** | `claude "Vytvor middleware pro rate limiting v ASP.NET Core"` |

### Doporucene nastaveni v settings.json

```json
{
  "permissions": {
    "allow": [
      "Bash(dotnet test:*)",
      "Bash(dotnet build:*)",
      "Bash(dotnet ef:*)",
      "Bash(docker compose:*)"
    ],
    "deny": [
      "Bash(rm -rf:*)",
      "Read(./appsettings.Production.json)",
      "Read(./**/secrets.json)"
    ]
  },
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "echo 'Running: $command' >> ~/.claude/audit.log"
      }]
    }]
  }
}
```

---

## 🔄 Univerzalni workflow (Frontend + Backend)

### Zacatek dne

```bash
claude -c                    # Pokracovat ve vcereji praci
/resume feature-auth         # Nebo obnovit konkretni session
/context                     # Zkontrolovat vyuziti tokenu
```

### Behem vyvoje

```bash
/plan                        # Review pred aplikaci zmen
@src/components/MyComponent.vue  # Rychla reference Vue souboru
@Controllers/UsersController.cs  # Rychla reference .NET souboru
! npm test                   # Spustit frontend testy
! dotnet test                # Spustit backend testy
```

### Pred pushem

```bash
claude "Vytvor commit s konvencni zpravou"
claude "Vytvor PR s popisem zmen"
```

### CI/CD pipeline

```bash
# Code review v GitHub Actions
gh pr diff "$PR_NUMBER" | claude -p \
  --append-system-prompt "Jsi security inzenyr" \
  --output-format json \
  --max-turns 2 \
  "Proved code review a vrat JSON s findings"
```

---

## CLI flagy a moznosti prikazove radky

Flag `-p` (print) transformuje Claude Code z interaktivniho asistenta na skriptovatelny automatizacni nastroj, zatimco flagy pro opravneni jako `--allowedTools` poskytuji jemnozrnnou kontrolu nad tim, jake akce muze Claude provadet bez lidskeho schvaleni.

### Zakladni prikazy

| Prikaz | Popis |
|--------|-------|
| `claude` | Spustit interaktivni REPL |
| `claude "dotaz"` | Spustit REPL s uvodni vyzvu |
| `claude -p "dotaz"` | Neinteraktivni headless rezim |
| `cat soubor \| claude -p "dotaz"` | Zpracovat pipovany obsah |
| `claude -c` | Pokracovat v nejnovejsi konverzaci |
| `claude -r "<session-id>"` | Obnovit konkretni session podle ID |
| `claude update` | Aktualizovat na nejnovejsi verzi |
| `claude mcp` | Konfigurovat MCP servery |

### Flagy headless rezimu

| Flag | Popis | Priklad |
|------|-------|---------|
| `--print`, `-p` | Vytisknout odpoved bez interaktivniho rezimu | `claude -p "vysvetli tento kod"` |
| `--output-format` | Format vystupu: `text`, `json`, `stream-json` | `claude -p --output-format json "dotaz"` |
| `--input-format` | Format vstupu: `text`, `stream-json` | `claude -p --input-format stream-json` |
| `--max-turns` | Omezit agenticke tahy v neinteraktivnim rezimu | `claude -p --max-turns 3 "dotaz"` |
| `--json-schema` | Ziskat validovany JSON vystup odpovdajici schematu | `claude -p --json-schema '{...}' "dotaz"` |
| `--verbose` | Povolit podrobne logovani s plnym vystupem jednotlivych tahu | `claude --verbose` |
| `--include-partial-messages` | Zahrnout castecne streaming eventy (vyzaduje stream-json) | `claude -p --output-format stream-json --include-partial-messages` |

### Flagy opravneni

| Flag | Popis |
|------|-------|
| `--dangerously-skip-permissions` | Preskocit VSECHNY vyzvy k opravneni (pouzivat s krajni opatrnosti) |
| `--allowedTools` | Nastroje povolene bez vyzvy (aditivni k settings.json) |
| `--disallowedTools` | Explicitne zakazane nastroje |
| `--permission-mode` | Spustit v rezimu: `default`, `acceptEdits`, `plan` |
| `--permission-prompt-tool` | MCP nastroj pro obsluhu vyzev k opravneni v headless rezimu |

**Syntaxe pravidel opravneni:** Pouzijte suffix `:*` pro prefixovy matching - napriklad `Bash(git diff:*)` povoli jakykoliv prikaz zacinajici na `git diff`.

### Vyber modelu

| Flag | Popis | Priklad |
|------|-------|---------|
| `--model` | Nastavit model podle aliasu nebo plneho nazvu | `claude --model opus` nebo `claude --model claude-sonnet-4-5-20250929` |
| `--fallback-model` | Automaticky fallback pri pretizeni defaultu (print rezim) | `claude -p --fallback-model sonnet "dotaz"` |

### Sprava session a konverzaci

| Flag | Popis |
|------|-------|
| `--continue`, `-c` | Nacist nejnovejsi konverzaci v aktualnim adresari |
| `--resume`, `-r` | Obnovit konkretni session podle ID |
| `--session-id` | Pouzit konkretni session ID (musi byt validni UUID) |
| `--fork-session` | Vytvorit nove session ID misto pouziti puvodniho |

### Prizpusobeni system promptu

| Flag | Chovani | Rezimy |
|------|---------|--------|
| `--system-prompt` | **Nahradi** cely defaultni prompt | Interaktivni + Print |
| `--system-prompt-file` | **Nahradi** obsahem souboru | Pouze Print |
| `--append-system-prompt` | **Pripoji** k defaultnimu promptu (doporuceno) | Interaktivni + Print |

Flag `--append-system-prompt` je doporucen pro vetisinu pripadu, protoze zachovava vestavenou funkcionalitu Claude Code a zaroven pridava vlastni instrukce.

### MCP konfigurace

| Flag | Popis |
|------|-------|
| `--mcp-config` | Nacist MCP servery z JSON souboru nebo retezcu |
| `--strict-mcp-config` | Pouzit pouze MCP servery z `--mcp-config`, ignorovat vsechny ostatni konfigurace |
| `--mcp-debug` | Povolit MCP debug rezim pro troubleshooting |

### Dalsi flagy

| Flag | Popis |
|------|-------|
| `--add-dir` | Pridat dalsi pracovni adresare |
| `--tools` | Specifikovat dostupne nastroje (`""` pro vypnuti, `"default"` pro vsechny, nebo nazvy nastroju) |
| `--settings` | Cesta k settings JSON souboru nebo JSON retezec |
| `--setting-sources` | Seznam zdroju nastaveni oddeleny carkou: `user`, `project`, `local` |
| `--agent` | Specifikovat agenta pro aktualni session |
| `--agents` | Definovat vlastni subagenty dynamicky pres JSON |
| `--plugin-dir` | Nacist pluginy z adresaru |
| `--ide` | Automaticky se pripojit k IDE pri spusteni |
| `--debug` | Povolit debug rezim s volitelnym filtrovanim kategorii |
| `--betas` | Beta hlavicky pro API pozadavky (pouze uzivatele s API klicem) |
| `--version`, `-v` | Zobrazit cislo verze |
| `--help` | Zobrazit napovedu |

---

## Klavesove zkratky

Tyto zkratky funguji v terminalovem rozhrani Claude Code. Klavesa **Escape** (ne Ctrl+C) je primarni zpusob preruseni generovani Claude.

### Obecne ovladani

| Zkratka | Popis |
|---------|-------|
| `Esc` | Zastavit aktualni akci Claude |
| `Esc` + `Esc` (dvakrat) | Vratit konverzaci/kod na predchozi checkpoint |
| `Ctrl+C` | Zrusit aktualni vstup |
| `Ctrl+D` | Ukoncit session Claude Code |
| `Ctrl+L` | Vycistit obrazovku terminalu (zachova konverzaci) |
| `Ctrl+O` | Prepnout podrobny vystup |
| `Ctrl+R` | Zpetne vyhledavani v historii prikazu |
| `Ctrl+B` | Presunout bash prikaz na pozadi |
| `Tab` | Prepnout rozsirene premysleni |
| `Shift+Tab` nebo `Alt+M` | Cyklovat rezimy opravneni (Normal -> Auto-Accept -> Plan) |
| `Sipky nahoru/dolu` | Navigace v historii prikazu |
| `?` | Zobrazit dostupne zkratky |

### Metody viceriadkoveho vstupu

| Metoda | Zkratka |
|--------|---------|
| Rychly escape | `\` + `Enter` (funguje ve vsech terminalech) |
| macOS default | `Option+Enter` |
| Nastaveni terminalu | `Shift+Enter` (po `/terminal-setup`) |
| Ridici sekvence | `Ctrl+J` |

### Rychle prefixove prikazy

| Prefix | Popis |
|--------|-------|
| `#` na zacatku | Zkratka pro pamet - pridat do CLAUDE.md |
| `/` na zacatku | Lomeny prikaz |
| `!` na zacatku | Bash rezim - spoustet prikazy primo |
| `@` | Zminka cesty k souboru - spustit autocomplete |

### Editace radku ve stylu Bash

| Zkratka | Akce |
|---------|------|
| `Ctrl+A` | Skocit na zacatek radku |
| `Ctrl+E` | Skocit na konec radku |
| `Option+F` / `Alt+F` | Posunout se o jedno slovo vpred |
| `Option+B` / `Alt+B` | Posunout se o jedno slovo zpet |
| `Ctrl+W` | Smazat predchozi slovo |

### Vkladani obrazku

Pouzijte `Ctrl+V` (macOS/Linux) nebo `Alt+V` (Windows) pro vlozeni obrazku ze schranky - funguje v iTerm2 a podporovanych terminalech.

---

## Vim rezim

Povolte prikazem `/vim` nebo nakonfigurujte trvale pres `/config`.

### Prepinani rezimu

| Prikaz | Akce |
|--------|------|
| `Esc` | Prejit do NORMAL rezimu z INSERT |
| `i` / `I` | Vkladat pred kurzor / na zacatek radku |
| `a` / `A` | Vkladat za kurzor / na konec radku |
| `o` / `O` | Otevrit radek nize / vyse |

### Navigace (NORMAL rezim)

| Prikaz | Akce |
|--------|------|
| `h`/`j`/`k`/`l` | Pohyb vlevo/dolu/nahoru/vpravo |
| `w` / `e` / `b` | Dalsi slovo / konec slova / predchozi slovo |
| `0` / `$` / `^` | Zacatek radku / konec / prvni neprazdny znak |
| `gg` / `G` | Zacatek / konec vstupu |

### Editace (NORMAL rezim)

| Prikaz | Akce |
|--------|------|
| `x` / `dd` / `D` | Smazat znak / radek / do konce |
| `dw`/`de`/`db` | Smazat slovo/do konce/zpet |
| `cc` / `C` | Zmenit radek / do konce radku |
| `cw`/`ce`/`cb` | Zmenit slovo/do konce/zpet |
| `.` | Opakovat posledni zmenu |

---

## Lomene prikazy

Vsechny vestaveene lomene prikazy dostupne v interaktivnim rezimu Claude Code.

### Sprava session

| Prikaz | Ucel |
|--------|------|
| `/clear` | Vycistit historii konverzace |
| `/compact [instrukce]` | Zkomprimovat konverzaci s volitelnymi instrukcemi pro zamereni |
| `/exit` | Ukoncit REPL |
| `/resume` | Obnovit predchozi konverzaci |
| `/rename` | Dat aktualni session zapamatovatelny nazev |
| `/rewind` | Vratit konverzaci a/nebo kod na predchozi bod |
| `/export [nazev_souboru]` | Exportovat aktualni konverzaci do souboru nebo schranky |

### Kontext a pamet

| Prikaz | Ucel |
|--------|------|
| `/context` | Vizualizovat aktualni vyuziti kontextu jako barevnou mrizku |
| `/memory` | Editovat soubory pameti CLAUDE.md |

### Model a konfigurace

| Prikaz | Ucel |
|--------|------|
| `/config` | Otevrit rozhrani nastaveni |
| `/model` | Vybrat nebo zmenit AI model |
| `/output-style [styl]` | Nastavit styl vystupu (napr. `/output-style explanatory`) |
| `/output-style:new` | Vygenerovat novy vlastni vystupni styl s pomoci Claude |
| `/permissions` | Zobrazit nebo aktualizovat opravneni |
| `/privacy-settings` | Zobrazit a aktualizovat nastaveni soukromi |
| `/vim` | Prejit do vim editacniho rezimu |

### Diagnostika a stav

| Prikaz | Ucel |
|--------|------|
| `/status` | Zobrazit verzi, model, ucet, pripojeni |
| `/doctor` | Zkontrolovat zdravi instalace Claude Code |
| `/cost` | Zobrazit statistiky pouziti tokenu |
| `/usage` | Zobrazit limity pouziti planu (pouze predplatne) |
| `/stats` | Zobrazit grafy pouziti, serii, historii session |

### Vyvojarske nastroje

| Prikaz | Ucel |
|--------|------|
| `/review` | Pozadat o code review |
| `/security-review` | Kompletni bezpecnostni review cekajicich zmen |
| `/todos` | Vypsat aktualni todo polozky |
| `/pr-comments` | Zobrazit komentare pull requestu |
| `/init` | Inicializovat projekt s pruvodcem CLAUDE.md |
| `/add-dir` | Pridat dalsi pracovni adresare |

### Terminal a IDE

| Prikaz | Ucel |
|--------|------|
| `/terminal-setup` | Nainstalovat klavesovou vazbu Shift+Enter |
| `/ide` | Spravovat IDE integrace |
| `/statusline` | Nastavit UI status line Claude Code |

### Autentizace

| Prikaz | Ucel |
|--------|------|
| `/login` | Prepnout Anthropic ucty |
| `/logout` | Odhlasit se z Anthropic uctu |

### Rozsireni a integrace

| Prikaz | Ucel |
|--------|------|
| `/mcp` | Spravovat pripojeni k MCP serverum |
| `/plugin` | Spravovat pluginy Claude Code |
| `/agents` | Spravovat vlastni AI subagenty |
| `/hooks` | Spravovat konfigurace hooku |
| `/install-github-app` | Nastavit Claude GitHub Actions |
| `/bashes` | Vypsat a spravovat ulohy na pozadi |
| `/sandbox` | Povolit sandboxovany bash nastroj |

### Napoveda a hlaseni

| Prikaz | Ucel |
|--------|------|
| `/help` | Ziskat napovedu k pouziti |
| `/bug` | Nahlasit chyby (odesle konverzaci do Anthropic) |
| `/release-notes` | Zobrazit poznamky k vydani |

### Vlastni lomene prikazy

Vytvorte vlastni prikazy umistenim markdown souboru do:
- `.claude/commands/` pro projektove prikazy (sdilene s tymem)
- `~/.claude/commands/` pro osobni prikazy (vsechny projekty)

**Priklad vlastniho prikazu** (`.claude/commands/fix-issue.md`):
```markdown
---
argument-hint: [cislo-issue]
description: Opravit GitHub issue
allowed-tools: Bash(gh:*)
---
Analyzuj a oprav GitHub issue #$1. Pouzij `gh issue view` pro ziskani detailu.
```

**Pouziti:** `/project:fix-issue 1234`

---

## Promenne prostredi

Chovani Claude Code lze rozsahle konfigurovat prostrednictvim promennych prostredi.

### API a autentizace

| Promenna | Ucel |
|----------|------|
| `ANTHROPIC_API_KEY` | API klic pro autentizaci Claude SDK |
| `ANTHROPIC_AUTH_TOKEN` | Vlastni hodnota Authorization hlavicky |
| `ANTHROPIC_CUSTOM_HEADERS` | Vlastni hlavicky (format: `Nazev: Hodnota`) |

### Konfigurace modelu

| Promenna | Ucel |
|----------|------|
| `ANTHROPIC_MODEL` | Prepsat defaultni model |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | Mapovani aliasu modelu Haiku |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | Mapovani aliasu modelu Sonnet |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | Mapovani aliasu modelu Opus |
| `CLAUDE_CODE_SUBAGENT_MODEL` | Model pro ulohy subagentu |

### Integrace s cloud providery

| Promenna | Ucel |
|----------|------|
| `CLAUDE_CODE_USE_BEDROCK=1` | Povolit Amazon Bedrock |
| `CLAUDE_CODE_USE_VERTEX=1` | Povolit Google Vertex AI |
| `CLAUDE_CODE_USE_FOUNDRY=1` | Povolit Microsoft Foundry |
| `AWS_REGION` | Vyzadovano pro Bedrock |
| `CLOUD_ML_REGION` | Region Vertex AI |
| `ANTHROPIC_VERTEX_PROJECT_ID` | GCP project ID pro Vertex |

### Konfigurace base URL a proxy

| Promenna | Ucel |
|----------|------|
| `ANTHROPIC_BASE_URL` | Prepsat base URL Anthropic API |
| `ANTHROPIC_BEDROCK_BASE_URL` | Prepsat base URL Bedrock |
| `ANTHROPIC_VERTEX_BASE_URL` | Prepsat base URL Vertex AI |
| `HTTP_PROXY` / `HTTPS_PROXY` | Konfigurace proxy serveru |
| `NO_PROXY` | Domeny k obejiti proxy |

### mTLS konfigurace

| Promenna | Ucel |
|----------|------|
| `CLAUDE_CODE_CLIENT_CERT` | Cesta k souboru klientskeho certifikatu |
| `CLAUDE_CODE_CLIENT_KEY` | Cesta k souboru soukromeho klice klienta |
| `CLAUDE_CODE_CLIENT_KEY_PASSPHRASE` | Heslo pro sifrovany klic |

### Konfigurace bash nastroje

| Promenna | Ucel |
|----------|------|
| `BASH_DEFAULT_TIMEOUT_MS` | Defaultni timeout bash prikazu |
| `BASH_MAX_TIMEOUT_MS` | Maximalni timeout, ktery muze model nastavit |
| `BASH_MAX_OUTPUT_LENGTH` | Max znaku pred zkracenim |
| `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` | Resetovat na projektovy adresar po kazdem prikazu |
| `CLAUDE_ENV_FILE` | Cesta ke skriptu nastaveni prostredi |
| `CLAUDE_CODE_SHELL` | Prepsat automatickou detekci shellu |
| `CLAUDE_CODE_SHELL_PREFIX` | Prikazovy prefix pro vsechny bash prikazy |

### Limity tokenu a vystupu

| Promenna | Ucel |
|----------|------|
| `CLAUDE_CODE_MAX_OUTPUT_TOKENS` | Max vystupnich tokenu pro pozadavky |
| `MAX_THINKING_TOKENS` | Povolit rozsirene premysleni s tokenovym rozpoctem |
| `MAX_MCP_OUTPUT_TOKENS` | Max tokenu pro odpovedi MCP nastroju (default: 25000) |
| `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS` | Prepsat limit tokenu pro cteni souboru |

### Ovladani cachovani promptu

| Promenna | Ucel |
|----------|------|
| `DISABLE_PROMPT_CACHING` | Vypnout vsechno cachovani promptu |
| `DISABLE_PROMPT_CACHING_HAIKU` | Vypnout cachovani pro Haiku |
| `DISABLE_PROMPT_CACHING_SONNET` | Vypnout cachovani pro Sonnet |
| `DISABLE_PROMPT_CACHING_OPUS` | Vypnout cachovani pro Opus |

### Telemetrie a soukromi

| Promenna | Ucel |
|----------|------|
| `DISABLE_TELEMETRY=1` | Odhlasit se z telemetrie |
| `DISABLE_ERROR_REPORTING=1` | Odhlasit se z hlaseni chyb |
| `DISABLE_BUG_COMMAND=1` | Vypnout prikaz `/bug` |
| `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1` | Vypnout autoupdater, bug command, error reporting, telemetrii |
| `DISABLE_AUTOUPDATER=1` | Vypnout automaticke aktualizace |

### OpenTelemetry export

| Promenna | Ucel |
|----------|------|
| `CLAUDE_CODE_ENABLE_TELEMETRY=1` | Povolit OTel export do vaseho kolektoru |
| `OTEL_METRICS_EXPORTER` | OTel metrics exporter |
| `OTEL_LOGS_EXPORTER` | OTel logs exporter |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | OTLP endpoint URL |
| `OTEL_LOG_USER_PROMPTS=1` | Zahrnout prompty v OTel logech |

### MCP konfigurace

| Promenna | Ucel |
|----------|------|
| `MCP_TIMEOUT` | Timeout spusteni MCP serveru (ms) |
| `MCP_TOOL_TIMEOUT` | Timeout spusteni MCP nastroje (ms) |

### Ruzne

| Promenna | Ucel |
|----------|------|
| `ANTHROPIC_LOG=debug` | Povolit detailni logovani |
| `CLAUDE_CONFIG_DIR` | Prizpusobit umisteni konfiguracniho adresare |
| `CLAUDE_CODE_TMPDIR` | Prepsat docasny adresar |
| `API_TIMEOUT_MS` | Timeout API pozadavku |
| `USE_BUILTIN_RIPGREP=0` | Pouzit systemovy `rg` misto vestaveeneho |

---

## Konfiguracni soubory

Claude Code pouziva hierarchii konfiguracnich souboru, pricemz vyssi urovne maji prednost.

### Hierarchie souboru (od nejvyssi po nejnizsi prioritu)

1. **Enterprise Managed Policies** (`managed-settings.json`)
   - macOS: `/Library/Application Support/ClaudeCode/managed-settings.json`
   - Linux/WSL: `/etc/claude-code/managed-settings.json`
   - Windows: `C:\Program Files\ClaudeCode\managed-settings.json`

2. **Argumenty prikazove radky**

3. **Lokalni nastaveni projektu** (`.claude/settings.local.json`) - osobni, gitignored

4. **Sdilena nastaveni projektu** (`.claude/settings.json`) - tyem sdilena, verzovana

5. **Uzivatelska nastaveni** (`~/.claude/settings.json`) - globalni osobni nastaveni

### Struktura settings.json

```json
{
  "permissions": {
    "allow": ["Bash(npm run lint)", "Bash(npm run test:*)", "Read(~/.zshrc)"],
    "ask": ["Bash(git push:*)"],
    "deny": ["Bash(curl:*)", "Read(./.env)", "Read(./secrets/**)"],
    "additionalDirectories": ["../docs/"],
    "defaultMode": "default",
    "disableBypassPermissionsMode": "disable"
  },
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1"
  },
  "model": "claude-sonnet-4-5-20250929",
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{ "type": "command", "command": "npx prettier --write $file" }]
    }]
  },
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["git", "docker"]
  },
  "apiKeyHelper": "/bin/generate_temp_api_key.sh",
  "includeCoAuthoredBy": true,
  "outputStyle": "Explanatory"
}
```

### Rezimy opravneni

| Rezim | Popis |
|-------|-------|
| `default` | Normalni interaktivni opravneni |
| `plan` | Rezim analyzy pouze pro cteni |
| `acceptEdits` | Automaticky prijmout editace souboru |
| `dontAsk` | Prijmout vsechna opravneni |
| `bypassPermissions` | Preskocit vsechny kontroly opravneni |

### MCP konfigurace (.mcp.json)

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://mcp.github.com/mcp",
      "headers": { "Authorization": "Bearer ${GITHUB_TOKEN}" }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/Users/me/projects"]
    }
  }
}
```

Expanze promennych prostredi podporuje syntaxi `${VAR}` a `${VAR:-default}`.

### Hook eventy

| Event | Kdy se spusti |
|-------|---------------|
| `PreToolUse` | Pred spustenim nastroje (muze blokovat) |
| `PostToolUse` | Po uspesnem dokonceni nastroje |
| `PostToolUseFailure` | Po selhani nastroje |
| `UserPromptSubmit` | Kdyz uzivatel odesle prompt |
| `SessionStart` / `SessionEnd` | Zivotni cyklus session |
| `PreCompact` | Pred komprimaci konverzace |
| `Notification` | Kdyz jsou odeslany notifikace |

---

## Tipy a workflow pro produktivitu

### Vzory pro pipovani a skriptovani

```bash
# Pipovat data do Claude
cat data.csv | claude -p "Kdo vyhral nejvice her?"

# JSON vystup pro programaticky parsing
session_id=$(claude -p "Zahajit review" --output-format json | jq -r '.session_id')
claude -p "Pokracovat" --resume "$session_id"

# CI/CD code review
gh pr diff "$1" | claude -p \
  --append-system-prompt "Jsi bezpecnostni inzenyr" \
  --output-format json \
  --allowedTools "Read,Grep"
```

### Doporucene postupy pro spravu session

Spousteni ruznych session pro ruzne ulohy je **tokenove nejefektivnejsi** pristup. Pouzivejte `/clear` casto mezi ulohami pro reset kontextu. Pri priblizeni se limitum kontextu Claude Code automaticky komprimuje shrnovanim kritickych detailu pri zachovani architektonickych rozhodnuti a nedavnych souboru.

### Spoustece rozsireneeho premysleni

Pouzijte klicova slova pro zvyseni hloubky premysleni: **"think"** < **"think hard"** < **"think harder"** < **"ultrathink"**

### Git worktrees pro paralelni session

```bash
git worktree add ../project-feature-a -b feature-a
cd ../project-feature-a && claude
```

Kazdy worktree ma izolovane soubory pri sdileni Git historie - idealni pro paralelni Claude Code session na ruznych featurach.

### @ zminky pro efektivni kontext

```
@src/components/Login.vue     # Reference Vue komponenty
@Controllers/AuthController.cs # Reference .NET controlleru
@./src/                       # Reference adresare
@github:issue://123           # Reference MCP zdroju
```

### Bash prikazy na pozadi

Stisknete `Ctrl+B` pro presun beziciho prikazu na pozadi (uzivatele Tmux: stisknete dvakrat). Pouzijte prefix `!` pro prime spusteni bash: `! npm test` spusti prikaz a prida vystup do kontextu konverzace.

### Struktura CLAUDE.md pameti

```markdown
# Prehled projektu
Strucny popis architektury

## Tech Stack
- Frontend: Vue 3 + Composition API, Pinia, Vite
- Backend: .NET 8, ASP.NET Core, EF Core

# Klicove prikazy
- `npm run test` - Spustit frontend testy (Vitest)
- `npm run lint` - Lintovat frontend
- `dotnet test` - Spustit backend testy (xUnit)
- `dotnet ef migrations add` - Pridat EF migraci

# Standardy kodovani
- Frontend: Vue 3 Composition API, TypeScript strict
- Backend: .NET konvence, async/await vsude
```

Umistete do korene projektu pro sdileni s tymem, nebo `~/.claude/CLAUDE.md` pro osobni globalni kontext.

---

## Zaver

Tento tahak pokryva cele spektrum schopnosti Claude Code - od **zakladnich klavesovych zkratek**, ktere zrychluje denni interakce, po **pokrocile automatizacni flagy**, ktere umoznuji sofistikovane CI/CD integrace.

### Klicove poznatky pro vyvojare

| Typ vyvojare | Nejdulezitejsi flagy | Nejdulezitejsi prikazy |
|--------------|---------------------|------------------------|
| **Frontend (Vue 3)** | `--append-system-prompt` (a11y), `--allowedTools` (lint) | `/plan`, `@komponenta.vue` |
| **Backend (.NET)** | `--max-turns`, `--output-format json`, pipe `\|` | `/model opus`, `! dotnet test` |
| **Fullstack** | `-c`, `-p`, `--model` | `/context`, `/compact`, `/resume` |
| **DevOps** | `--output-format json`, `--max-budget-usd` | CI/CD integrace, hooks |

### Top 5 okamzitych vylepseni produktivity

1. **`claude -c`** - Pokracujte v praci bez ztraceni kontextu
2. **`Shift+Tab`** - Prepinani rezimu opravneni (Normal/Auto-Accept/Plan)
3. **`Esc+Esc`** - Rychly rewind kdyz Claude jde spatnym smerem
4. **`-p --output-format json`** - Automatizace a CI/CD integrace
5. **`@soubor.ts`** - Explicitni reference misto "ten soubor"

### Doporucena struktura pro tymy

```
projekt/
├── .claude/
│   ├── settings.json      # Sdilena opravneni a hooks
│   ├── commands/          # Tymove custom prikazy
│   └── agents/            # Specializovani agenti
├── .mcp.json              # Integrace nastroju
└── CLAUDE.md              # Projektove standardy a pravidla
```

Pro detailni priklady pro vas typ projektu viz sekce [Priklady pro Frontend](#-priklady-pro-frontend-vyvojare) a [Priklady pro Backend](#-priklady-pro-backend-vyvojare) na zacatku tohoto dokumentu.

---

## Souvisejici

- [02-commands](../lessons/foundations/02-commands.md) - Vytvareni vlastnich lomenych prikazu
- [04-settings](../lessons/configuration/04-settings.md) - Konfigurace opravneni
- [04a-terminal-config](../lessons/configuration/04a-terminal-config.md) - Nastaveni terminalu
- [06-hooks](../lessons/configuration/06-hooks.md) - Automatizace pomoci hooku

---

**Posledni aktualizace:** 2026-01-22
