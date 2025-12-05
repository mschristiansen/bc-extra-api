# Warehouse Agent Knowledge Sources

Dette dokument beskriver de videnkilder (knowledge sources) som lagerassistenten bruger.

---

## 1. Business Central MCP Server (Primær)

### Beskrivelse
Real-time integration med Business Central via MCP-server for live lagerdata.

### Type
Custom Connector / API Plugin

### Konfiguration

| Parameter | Værdi |
|-----------|-------|
| Publisher | `mschristiansen` |
| Group | `warehouseAgent` |
| Version | `v1.0` |

### Tilgængelige Endpoints

#### lotInventory
Returnerer lagerbeholdning per (lot, bin) kombination.

**Felter:**
- `itemNo` - Varenummer (filtrerbar)
- `itemDescription` - Varebeskrivelse
- `lotNo` - Lotnummer (filtrerbar)
- `lotDescription` - Beskrivelse af pakken
- `certificateNumber` - FSC-certifikatnummer
- `balHeight` - Tykkelse i mm
- `balLengthInterval` - Længdeinterval
- `balWidthInterval` - Breddeinterval
- `binCode` - Lagerplacering (filtrerbar)
- `locationCode` - Lokationskode (filtrerbar)
- `quantity` - Mængde i denne bin
- `baseUnitOfMeasure` - Enhed (M3, M, STK)
- `blocked` - Om lot er blokeret

**OData-filtre eksempler:**
```
binCode eq 'HAL5'
startswith(itemNo, 'SA')
lotNo eq '105427'
```

#### lotReservations
Returnerer reservationer på lot-niveau.

**Felter:**
- `itemNo` - Varenummer (filtrerbar)
- `lotNo` - Lotnummer (filtrerbar)
- `locationCode` - Lokationskode (filtrerbar)
- `sourceType` - Kildetype (37=Salg, 5406=Prod.ordre, etc.)
- `sourceId` - Dokumentnummer
- `quantity` - Reserveret mængde (negativ = udgående)
- `expectedDate` - Forventet dato

---

## 2. Warehouse Knowledge Documents (Sekundær)

### Beskrivelse
Statisk videnbase med domæneviden om træsorter, beregningsformler, dimensioner og forretningsregler. Opdelt i mindre filer for bedre retrieval.

### Type
File Upload (Markdown)

### Filer
`warehouse-knowledge/` mappe med følgende filer:

| Fil | Indhold |
|-----|---------|
| `api-reference.md` | BC integration, API-kald, filtre, dataformater, varenumre |
| `calculations.md` | Omregningsformler, vægt, savsnit, optimering, spild, krumning |
| `business-rules.md` | Kvalitet, FSC, høvletillæg, pakkevalg, S-kvalitet prioritering |
| `machines.md` | Maskinpark, kapaciteter, maskinvalg |
| `wood-species.md` | Træsorter med koder, vægt per m³ (30+ arter), typiske dimensioner |
| `locations.md` | Lagerplaceringer (bins) |

### Beregningskapabiliteter

Agenten kan udføre følgende beregninger ved at kombinere formler fra `calculations.md` med vægtdata fra `wood-species.md`:

| Beregning | Formel | Eksempel |
|-----------|--------|----------|
| Volumen | `m³ = (t×b×l×stk) / 1.000.000` | 52×100mm, 3,2m, 50stk = 0,832 m³ |
| Vægt | `kg = m³ × vægt_per_m³` | 0,08 m³ Sapelli = 50,4 kg |
| Emner fra pakke | `floor(pakke / (emne + savsnit))` | 5,5m → 3 stk 1,8m emner |
| Lister fra bræt | `floor(bredde / (liste + savsnit))` | 147mm → 2 stk 65mm lister |
| Krumningsreduktion | `ny = orig × (ny_l / orig_l)` | 3m/12cm → 1,5m/6cm |

### Markér som Official Source
**Ja** - Dette er verificeret domæneviden som kan bruges direkte.

---

## 3. Generative AI Settings

### General Knowledge
**Slået FRA** - Agenten skal kun bruge de konfigurerede videnkilder, ikke generel AI-viden.

### Web Search
**Slået FRA** - Agenten skal ikke søge på internettet.

---

## Knowledge Source Prioritering

| Prioritet | Kilde | Anvendelse |
|-----------|-------|------------|
| 1 | Business Central MCP | Live lagerdata, beholdninger, reservationer |
| 2 | warehouse-knowledge.md | Domæneviden, beregninger, forretningsregler |

---

## Begrænsninger

### Data som IKKE er tilgængelig
- Kostpris/værdi per lot
- Historiske transaktioner
- Kundeoplysninger
- Salgsordredetaljer (kun reservationshenvisning)

### API-begrænsninger
- OData-filtrering kun på: `itemNo`, `lotNo`, `binCode`, `locationCode`
- Andre felter skal filtreres i hukommelsen efter datahentning
- Kun rækker med `quantity > 0` returneres

---

## Opdateringsfrekvens

| Kilde | Frekvens |
|-------|----------|
| Business Central MCP | Real-time (live API-kald) |
| warehouse-knowledge.md | Statisk (opdateres manuelt ved ændringer) |
