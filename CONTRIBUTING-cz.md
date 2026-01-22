# Prispivani a synchronizace

> Jak udrzet lokalni kopii synchronizovanou s upstream repozitarem a zachovat sve vlastni upravy.

---

## Rychly start pro vyvojare

### Prvni nastaveni

```bash
# Klonovat repozitar
git clone https://github.com/YOUR-ORG/agentic-engineer-playbook.git
cd agentic-engineer-playbook

# Pridat upstream remote (pri forkovani)
git remote add upstream https://github.com/YOUR-ORG/agentic-engineer-playbook.git
```

### Synchronizace

```bash
# Stahnout nejnovejsi zmeny z origin
git fetch origin

# Mergovat aktualizace (vase local/ slozky jsou gitignorovane, bezpecne)
git pull origin main
```

---

## Kam umistit vlastni upravy

### Gitignorovane lokace (bezpecne pred konflikty)

| Co | Kam | Priklad |
|----|-----|---------|
| Osobni prikazy | `.claude/commands/local/` | `local/muj-review.md` |
| Osobni agenti | `.claude/agents/local/` | `local/muj-helper.md` |
| Lokalni CLAUDE.md doplnky | `CLAUDE.local.md` | Projektove specificky pravidla |
| Poznamky | `scratch/` | `scratch/poznamky.md` |

**Tyto slozky jsou gitignorovane** — vase zmeny zustavaji lokalni a nebudou v konfliktu s upstream aktualizacemi.

### Vytvareni lokalnich prikazu

```bash
# Vytvorit slozku pro lokalni prikazy
mkdir -p .claude/commands/local

# Pridat osobni prikaz
cat > .claude/commands/local/moje-zkratka.md << 'EOF'
---
description: Moje osobni zkratka pro X
---

Udelej vec, kterou porad potrebuju...
EOF
```

Vas prikaz se objevi jako `/local:moje-zkratka` v Claude Code.

### Pouziti CLAUDE.local.md

Vytvorte `CLAUDE.local.md` v rootu projektu pro osobni pravidla:

```markdown
# Moje lokalni pravidla

## Projektova specifika
- Nase API base URL je https://api.example.com
- V tomto projektu pouzivej ceske komentare

## Moje preference
- Vzdy pouzivej TypeScript strict mode
- Preferuj funkcni komponenty
```

Claude Code automaticky cte jak `CLAUDE.md` tak `CLAUDE.local.md`.

---

## Co NEMODIFIKOVAT

Tyto adresare dostávají pravidelne upstream aktualizace. **Nemodifikujte primo:**

| Adresar | Obsah | Proc |
|---------|-------|------|
| `lessons/` | Vyukove moduly | Bude aktualizovano novym obsahem |
| `reference/` | Referencni dokumenty | Dostava opravy a doplnky |
| `agentic-coding/` | TAD skoleni | Nove moduly se pridavaji pravidelne |
| `.claude/commands/workflows/` | Sdilene tymove workflow | Koordinovane aktualizace |

**Pokud potrebujete upravit workflow**, zkopirujte ho do `.claude/commands/local/` a upravte kopii.

---

## Scenare prace

### Scenar 1: Chci upravit prikaz

```bash
# Zkopirovat do local (gitignorovano)
cp .claude/commands/workflows/feature.md .claude/commands/local/muj-feature.md

# Upravit kopii
# Ted pouzijte /local:muj-feature misto /feature
```

### Scenar 2: Upstream aktualizoval soubor, ktery jsem modifikoval

Pokud jste omylem modifikovali trackovany soubor:

```bash
# Schovat zmeny
git stash

# Stahnout aktualizace
git pull origin main

# Prozkoumat co jste schovaly
git stash show -p

# Bud zahodte stash nebo selektivne znovu aplikujte
git stash drop  # pokud chcete zahodit
# NEBO
git stash pop   # pokud chcete znovu aplikovat (muze konfliktovat)
```

### Scenar 3: Chci prispet zpet

Pokud jste vytvorili neco uzitecneho pro cely tym:

1. Presunte to z `local/` do spravne trackovane lokace
2. Vytvorte vetev: `git checkout -b feature/muj-prikaz`
3. Commitnete a pushnete: `git push -u origin feature/muj-prikaz`
4. Otevrete Pull Request

---

## Reference struktury adresaru

```
agentic-engineer-playbook/
├── CLAUDE.md                    # Sdileny (trackovany)
├── CLAUDE.local.md              # Osobni (gitignorovany)
├── lessons/                     # Read-only vyukovy obsah
├── reference/                   # Read-only referencni dokumenty
├── agentic-coding/              # Read-only TAD moduly
├── .claude/
│   ├── commands/
│   │   ├── workflows/           # Sdilene prikazy (trackovane)
│   │   ├── tools/               # Sdilene nastroje (trackovane)
│   │   └── local/               # Vase prikazy (gitignorovane)
│   ├── agents/
│   │   ├── *.md                 # Sdileni agenti (trackovani)
│   │   └── local/               # Vasi agenti (gitignorovani)
│   └── settings.json            # Sdilene nastaveni (trackovane)
│   └── settings.local.json      # Vase nastaveni (gitignorovane)
└── scratch/                     # Osobni poznamky (gitignorovane)
```

---

## Tipy

1. **Spustte `/prime` po pullnuti** pro obnoveni Claude pochopeni noveho obsahu

2. **Zkontrolujte changelog** (`CHANGELOG.md`) abyste videli co je noveho po pullnuti

3. **Pouzijte `~/.claude/` pro cross-projektove nastaveni** — tyto se aplikuji na vsechny vase Claude Code sessions, nejen tento repozitar

4. **V pripade pochybnosti pouzijte `local/`** — je vzdy bezpecne pred merge konflikty

---

## Souvisejici dokumentace

- [Shortcuts (CZ)](reference/shortcuts-cz.md) — Kompletni tahak (80+ flagu, 30+ prikazu)
- [Statusline Guide (CZ)](reference/settings/statusline-guide-cz.md) — Konfigurace stavoveho radku
