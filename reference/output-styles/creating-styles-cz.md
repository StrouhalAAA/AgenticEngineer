# Průvodce vlastními výstupními styly

> Rychlá reference pro vytváření a použití výstupních stylů Claude Code.

---

## Co jsou výstupní styly?

Výstupní styly řídí **jak Claude odpovídá** - míru podrobnosti, strukturu a formátování. Snižují spotřebu tokenů a zajišťují konzistentní formát odpovědí napříč vaším týmem.

**Umístění:** `.claude/output-styles/<nazev-stylu>.md`

---

## Vytvoření vlastního výstupního stylu

### 1. Struktura souboru

```markdown
---
name: <Zobrazovaný název>
description: <Jednořádkový popis, kdy tento styl použít>
---

# <Název stylu>

<Instrukce pro Claude, jak formátovat odpovědi>

## Struktura odpovědi
<Definujte sekce, nadpisy, pravidla formátování>

## Pravidla formátování
<Konkrétní konvence: odrážky, bloky kódu, zvýraznění>

## Příklad výstupu
<Ukažte Claude, jak má dobrá odpověď vypadat>
```

### 2. Minimální příklad

```markdown
---
name: Odrážkový souhrn
description: Stručné odpovědi v odrážkách pro rychlé skenování
---

# Styl odrážkového souhrnu

Odpovídej pouze pomocí odrážek:
- Maximálně 3 úrovně vnořování
- Každá odrážka: maximálně 1-2 řádky
- Žádné odstavce, žádný souvislý text
- Začni souhrnnou odrážkou, pak detaily
```

### 3. Klíčové sekce k zahrnutí

| Sekce | Účel |
|-------|------|
| `name` (frontmatter) | Zobrazovaný název v UI/CLI |
| `description` (frontmatter) | Kdy tento styl použít |
| Struktura odpovědi | Definuje požadované sekce |
| Pravidla formátování | Konvence pro zvýraznění, kód, seznamy |
| Příklad výstupu | Ukáže očekávaný formát |
| Výjimky | Kdy se od pravidel odchýlit |

---

## Použití výstupních stylů

### Metoda 1: CLI přepínač (pro jednu relaci)

```bash
# Spuštění Claude Code s konkrétním výstupním stylem
claude --output-style <nazev-stylu>

# Příklady z tohoto repozitáře:
claude --output-style concise-done
claude --output-style verbose-bullet-points
claude --output-style pedagogical-knowledge-transfer
```

### Metoda 2: Příkaz během relace

```
/output-style <nazev-stylu>
```

### Metoda 3: Konfigurace v nastavení

V `.claude/settings.json` nebo `.claude/settings.local.json`:

```json
{
  "outputStyle": "pedagogical-knowledge-transfer"
}
```

### Metoda 4: Kombinace s dalšími přepínači

```bash
# Výstupní styl + výběr modelu + přeskočení oprávnění
claude --output-style concise-done --model sonnet --dangerously-skip-permissions
```

---

## Výstupní styly v tomto repozitáři

| Styl | Soubor | Použití |
|------|--------|---------|
| `concise-done` | `concise-done.md` | Minimální výstup, pouze "Hotovo." |
| `concise-ultra` | `concise-ultra.md` | Ultra-stručné odpovědi |
| `concise-tts` | `concise-tts.md` | Optimalizováno pro převod textu na řeč |
| `verbose-bullet-points` | `verbose-bullet-points.md` | Hierarchické odrážky pro skenování |
| `verbose-yaml-structured` | `verbose-yaml-structured.md` | Odpovědi ve formátu YAML |
| `pedagogical-knowledge-transfer` | `pedagogical-knowledge-transfer.md` | Výuka/učení v týmu |

---

## Doporučené postupy

### DĚLEJTE:
- **Pojmenujte jasně** - Název stylu by měl naznačovat jeho účel
- **Poskytněte příklady** - Claude lépe následuje příklady než abstraktní pravidla
- **Definujte výjimky** - Kdy se má Claude od stylu odchýlit?
- **Udržujte zaměření** - Jeden styl = jeden vzor výstupu

### NEDĚLEJTE:
- Nemíchejte více výstupních filozofií v jednom stylu
- Nedělejte styly příliš rigidní (umožněte okrajové případy)
- Nezapomínejte na `description` - pomůže vám pamatovat si, kdy styl použít

---

## Reference dopadu na tokeny

| Typ stylu | Typický výstup | Úspora tokenů |
|-----------|----------------|---------------|
| Stručný (Done) | ~5-10 tokenů | 95%+ redukce |
| Stručný (Ultra) | ~50 tokenů | 80-90% redukce |
| Odrážky | ~200 tokenů | 50-60% redukce |
| YAML strukturovaný | ~300 tokenů | 40-50% redukce |
| Pedagogický | ~500+ tokenů | Vzdělávací (záměrně podrobný) |

> **Poznámka k R&D frameworku:** Výstupní styly jsou technika **Reduce** - minimalizují výstupní tokeny, které se kumulují ve vašem kontextovém okně během více výměn.

---

## Šablona pro rychlý start

Zkopírujte toto do `.claude/output-styles/<vas-styl>.md`:

```markdown
---
name: Můj vlastní styl
description: Stručný popis, kdy tento styl použít
---

# Můj vlastní styl

[Hlavní instrukce pro Claude - jaký druh odpovědí generovat]

## Struktura odpovědi

[Definujte sekce, které by měla každá odpověď obsahovat]

## Pravidla formátování

- [Pravidlo 1]
- [Pravidlo 2]
- [Pravidlo 3]

## Příklad

[Ukažte příklad očekávaného formátu výstupu]
```

Poté použijte pomocí:
```bash
claude --output-style muj-vlastni-styl
```
