# Agentic Engineer Playbook - Mapa učení

> Vizuální průvodce pro vývojáře učící se Claude Code

## Changelog

| Verze | Datum | Změny |
|-------|-------|-------|
| 1.0 | 2026-01-22 | První verze - základní mapa učení |

---

## Co tento repozitář učí

```mermaid
flowchart LR
    REPO[Tento repozitář] --> GOAL[Zvládnout Claude Code]
    GOAL --> A[Psát efektivní prompty]
    GOAL --> B[Vytvářet znovupoužitelné příkazy]
    GOAL --> C[Konfigurovat pro tým]
    GOAL --> D[Škálovat na enterprise]
```

---

## Cesta učení

```mermaid
flowchart TD
    START[🚀 START_HERE.md] --> L1

    subgraph L1["1. Základy - 50 min"]
        F1[Základní koncepty] --> F2[Příkazy] --> F3[Skills]
    end

    L1 --> L2

    subgraph L2["2. Konfigurace - 90 min"]
        C1[Nastavení] --> C2[Terminál] --> C3[Model] --> C4[CLAUDE.md] --> C5[Hooky]
    end

    L2 --> L3

    subgraph L3["3. Správa kontextu - 60 min"]
        X1[Subagenti] --> X2[Forknutý kontext]
    end

    L3 --> L4

    subgraph L4["4. Rozšiřitelnost - 65 min"]
        E1[MCP] --> E2[Pluginy] --> E3[LSP]
    end

    L4 --> ADV[🎓 Pokročilé: TAD Training]

    style START fill:#c8e6c9,stroke:#2e7d32
    style ADV fill:#f3e5f5,stroke:#7b1fa2
```

---

## Rychlý přehled: Kde co najít

```mermaid
flowchart LR
    subgraph LEARN["📚 K učení"]
        A1[lessons/] --> A2[Tutoriály krok za krokem]
        A3[agentic-coding/] --> A4[Pokročilý TAD training]
    end

    subgraph LOOKUP["📖 K vyhledání"]
        B1[reference/] --> B2[Rychlé odpovědi a příklady]
        B3[reference/expert-patterns/] --> B4[Techniky pro power-usery]
    end

    subgraph USE["⚡ K použití"]
        C1[.claude/commands/] --> C2[Spustit pomocí /název-příkazu]
        C3[team-template/] --> C4[Zkopírovat do projektu]
    end
```

---

## Vyber si svou cestu

| Cesta | Čas | Pro koho | Začni s |
|-------|-----|----------|---------|
| **Rychlý start** | 1 hodina | Chci být rychle produktivní | Lekce 01, 04, 05, 02 |
| **Kompletní kurz** | 4.5 hodiny | Chci úplné pochopení | Všechny lekce 01-11 |
| **Power User** | 2 hodiny | Už znám základy | Lekce 04a-c, 07-08, expert-patterns |

---

## Přehled adresářů

| Složka | Co obsahuje |
|--------|-------------|
| `lessons/` | 11 tutoriálů ve 4 sekcích |
| `reference/` | Dokumenty pro rychlé vyhledání, příklady, vzory |
| `agentic-coding/` | Enterprise-scale training (TAD) |
| `.claude/` | Funkční příkazy, které můžeš spustit |
| `team-template/` | Připravená konfigurace pro tým |

