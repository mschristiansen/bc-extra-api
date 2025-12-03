# Warehouse Agent Topics

Dette dokument beskriver de konversationsemner (topics) som lagerassistenten håndterer.

---

## 1. Søg efter Træsort

**Trigger Phrases:**
- "Find [træsort] på lager"
- "Har vi [træsort]?"
- "Vis [træsort] pakker"
- "Søg efter eg/sapelli/douglas/..."
- "Hvad har vi af [træsort]?"

**Conversation Flow:**
1. Identificér træsort fra brugerens input (brug træsortskoder: EE=eg, SA=sapelli, DO=douglas, etc.)
2. Kald `lotInventory` API med filter: `startswith(itemNo, '[KODE]')`
3. Præsenter resultater grupperet efter dimension/kvalitet
4. Spørg om brugeren vil have mere specifik filtrering

**Entities:**
- `træsort`: Træsortens navn eller kode
- `kvalitet`: A, B, eller S (valgfri)
- `certificering`: FSC eller ucertificeret (valgfri)

---

## 2. Søg efter Dimensioner

**Trigger Phrases:**
- "Find [tykkelse]mm planker"
- "Har vi [tykkelse] x [bredde]?"
- "Søg efter 26mm"
- "Find brædder til terrassegulv"
- "Vis 52mm eg"

**Conversation Flow:**
1. Parse dimensioner fra input (tykkelse, bredde)
2. Bestem om det er savskåret eller høvlet mål
3. For høvlede mål: Beregn minimum savskåret dimension (+5-7mm)
4. Kald API og filtrer resultater på `balHeight`
5. Vis matchende pakker med fulde dimensioner

**Entities:**
- `tykkelse`: Tykkelse i mm
- `bredde`: Bredde i mm (valgfri)
- `længde`: Minimum længde (valgfri)

---

## 3. Søg efter Placering (Bin)

**Trigger Phrases:**
- "Hvad har vi i [bin]?"
- "Vis indhold af Hal5"
- "Hvad ligger i Hal2?"
- "Liste over pakker i [placering]"

**Conversation Flow:**
1. Identificér bin-kode fra input (HAL2, HAL3, HAL4, HAL5, VM, P, Fra-P, etc.)
2. Kald `lotInventory` API med filter: `binCode eq '[BINKODE]'`
3. Præsenter resultater sorteret efter træsort/dimension
4. Opsummér totaler per træsort

**Entities:**
- `binCode`: Lagerplacering (HAL2, HAL3, HAL4, HAL5, VM, P, Fra-P, AZOBE, BLOK, SIDE, SKIBS)

---

## 4. Find Specifikt Lot

**Trigger Phrases:**
- "Find lot [nummer]"
- "Hvor er pakke [nummer]?"
- "Vis information om lot [nummer]"
- "Hvad ved vi om pakke 105427?"

**Conversation Flow:**
1. Identificér lotnummer (6 cifre)
2. Kald `lotInventory` API med filter: `lotNo eq '[LOTNR]'`
3. Kald `lotReservations` API med filter: `lotNo eq '[LOTNR]'`
4. Beregn tilgængelig mængde: inventory + reservations (negative)
5. Vis komplet information inkl. alle bins hvor lot findes

**Entities:**
- `lotNo`: Lotnummer (6 cifre)

---

## 5. Tjek Tilgængelighed

**Trigger Phrases:**
- "Er lot [nummer] tilgængelig?"
- "Hvad er tilgængeligt af [lot]?"
- "Kan jeg bruge pakke [nummer]?"
- "Er der reservationer på [lot]?"

**Conversation Flow:**
1. Identificér lotnummer
2. Hent lagerbeholdning fra `lotInventory`
3. Hent reservationer fra `lotReservations`
4. Beregn: Tilgængelig = Inventory + Reservationer (negative tal)
5. Vis opdeling: Total beholdning, Reserveret, Tilgængelig
6. Nævn hvad reservationerne er til (salgsordre, produktion, etc.)

**Entities:**
- `lotNo`: Lotnummer

---

## 6. Behovsanalyse (Længdenotation)

**Trigger Phrases:**
- "Jeg skal bruge 3/3.0 4/3.3 10/0.5"
- "Find materiale til [styk/længde]"
- "Kan vi dække [længdebehov]?"
- "Optimer afkortning for [liste]"

**Conversation Flow:**
1. Parse længdenotation (styk/længde format)
2. Beregn total løbende meter behov
3. Søg efter matchende pakker
4. Evaluer spild for hver kandidatpakke
5. Anbefal pakker med mindst spild
6. Vis beregninger for emner per planke

**Entities:**
- `længdebehov`: Liste af styk/længde kombinationer
- `træsort`: Ønsket træsort
- `dimensioner`: Ønskede dimensioner

---

## 7. Omregning mellem Enheder

**Trigger Phrases:**
- "Omregn [mængde] m³ til løbende meter"
- "Hvor mange styk er [mængde] lbm?"
- "Konverter [mængde] til m³"
- "Hvad svarer [mængde] m³ til i 26x147?"

**Conversation Flow:**
1. Identificér kildeenhed og mængde
2. Identificér målenhed
3. Bed om dimensioner hvis nødvendigt
4. Udfør beregning med formlerne:
   - m³ = (tykkelse × bredde × længde × styk) / 1.000.000
   - lbm = (m³ × 1.000.000) / (tykkelse × bredde)
   - styk = lbm / længde
5. Vis resultat med beregningsforklaring

**Entities:**
- `mængde`: Numerisk værdi
- `kildeEnhed`: m³, lbm, stk
- `målEnhed`: m³, lbm, stk
- `dimensioner`: Tykkelse og bredde

---

## 8. Savskåret til Høvlet Beregning

**Trigger Phrases:**
- "Hvad skal jeg bruge til høvlet [dim]?"
- "Kan 26x147 høvles til 21x140?"
- "Find materiale til høvlet [mål]"
- "Savskåret dimension for [færdig dimension]"

**Conversation Flow:**
1. Identificér ønsket færdig (høvlet) dimension
2. Beregn minimum savskåret: færdig + 5-7mm per dimension
3. Søg efter savskåret materiale der opfylder kravet
4. Vis konverteringstabel
5. Anbefal tilgængelige pakker

**Entities:**
- `høvletTykkelse`: Færdig tykkelse
- `høvletBredde`: Færdig bredde

---

## 9. Blokerede Pakker

**Trigger Phrases:**
- "Vis blokerede pakker"
- "Hvad er i karantæne?"
- "Er lot [nummer] blokeret?"
- "Hvorfor er pakke [nummer] blokeret?"

**Conversation Flow:**
1. Kald `lotInventory` API
2. Filtrer resultater hvor `blocked = true`
3. Vis liste med lotnumre, beskrivelser og placeringer
4. Forklar at blokerede pakker ikke bør sælges uden godkendelse

---

## 10. FSC-certificeret Materiale

**Trigger Phrases:**
- "Find FSC [træsort]"
- "Har vi certificeret eg?"
- "Vis FSC-pakker"
- "Jeg skal bruge FSC materiale"

**Conversation Flow:**
1. Identificér træsort hvis angivet
2. Søg efter varer hvor varenummer indeholder 'F' på position 5 (certificering)
3. Eller filtrer resultater hvor `certificateNumber` ikke er tom
4. Vis certificeringsnummer for hver pakke
5. Forklar FSC-substitutionsregler

---

## System Topics

### Conversation Start
**Trigger:** Når en ny samtale starter

**Message:**
"Hej! Jeg er din lagerassistent. Jeg kan hjælpe dig med at:
- Finde træmaterialer på lageret
- Tjekke tilgængelighed og reservationer
- Beregne materialebehov og spild
- Omregne mellem enheder

Hvad kan jeg hjælpe med?"

---

### Escalate
**Trigger:** Når assistenten ikke kan hjælpe

**Trigger Phrases:**
- "Tal med en person"
- "Jeg har brug for hjælp fra en medarbejder"
- "Kan jeg tale med nogen?"

**Message:**
"Jeg kan desværre ikke hjælpe med dette. Kontakt venligst lagermedarbejderen direkte for yderligere assistance."

---

### Fallback
**Trigger:** Når brugerens forespørgsel ikke matcher nogen topics

**Message:**
"Jeg forstår desværre ikke din forespørgsel. Prøv at spørge om:
- Lagerbeholdning af en specifik træsort
- Information om et lotnummer
- Hvad der ligger på en bestemt placering
- Omregning mellem enheder

Kan du omformulere dit spørgsmål?"

---

### End of Conversation
**Trigger:** Når samtalen afsluttes

**Trigger Phrases:**
- "Tak for hjælpen"
- "Det var alt"
- "Farvel"

**Message:**
"Tak fordi du brugte lagerassistenten. God arbejdslyst!"
