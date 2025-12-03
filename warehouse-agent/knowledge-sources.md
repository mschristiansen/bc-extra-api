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

## 2. Warehouse Knowledge Document (Sekundær)

### Beskrivelse
Statisk videnbase med domæneviden om træsorter, beregningsformler, dimensioner og forretningsregler.

### Type
File Upload (Markdown)

### Fil
`warehouse-knowledge.md`

### Indhold
- Varenummerformat og afkodning
- Træsortstabel med koder og navne
- Mængdeenheder og omregningsformler
- Savskåret vs høvlet konvertering
- Kvalitets- og certificeringsregler
- Lagerplaceringer (bins) beskrivelse
- Typiske dimensioner per træsort
- Optimeringsberegninger for spild

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
