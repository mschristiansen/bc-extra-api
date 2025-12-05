# Beregninger og Formler

Reference for omregning, vægtberegning, spildoptimering og udbytteberegning.

## Mængdeenheder

Træ lagres i en af tre enheder:
- **m³** (kubikmeter) - volumen
- **m** eller **lbm** (løbende meter) - total længde
- **stk** (styk/pieces) - antal

**Hvilken enhed gælder:**

| Bredde | Længde | Enhed |
|--------|--------|-------|
| Varierende | Enhver | m³ |
| Fast | Varierende | m (lbm) |
| Fast | Fast | stk |

## Omregningsformler

**Omregning til m³:**
```
m³ = (tykkelse_mm × bredde_mm × længde_m × styk) / 1.000.000
```

**Omregning fra m³ til løbende meter (lbm):**
```
lbm = (m³ × 1.000.000) / (tykkelse_mm × bredde_mm)
```

**Omregning fra løbende meter til styk:**
```
styk = lbm / længde_m
```

**Eksempel:**
- 52mm × 100mm planker, 3,2m lange, 50 styk
- m³ = (52 × 100 × 3,2 × 50) / 1.000.000 = 0,832 m³
- Eller: lbm = 3,2m × 50 = 160 lbm → m³ = (160 × 52 × 100) / 1.000.000 = 0,832 m³

## Vægtberegning

**Formel:**
```
vægt_kg = m³ × vægt_kg_per_m³
```

**Vægt per m³ for almindelige træsorter:**

| Kode | Træsort | Vægt (kg/m³) |
|------|---------|--------------|
| EE | Europæisk Eg | 720 |
| EA | Amerikansk Eg | 750 |
| SA | Sapelli | 630 |
| SI | Sipo | 650 |
| TI | Tiama | 560 |
| AZ | Azobé | 1070 |
| IP | Ipé | 1050 |
| JA | Jatoba | 910 |
| CU | Cumaru | 1090 |
| ME | Merbau | 800 |
| WE | Wengé | 870 |
| IR | Iroko | 660 |
| AE | Europæisk Ask | 700 |
| AA | Amerikansk Ask | 670 |
| AT | Thermo Ask | 600 |
| BE | Bøg | 720 |
| BI | Birk | 650 |
| AH | Ahorn | 700 |
| VA | Amerikansk Valnød | 610 |
| TP | Plantage Teak | 670 |
| DO | Douglas | 530 |
| LE | Europæisk Lærk | 590 |
| LS | Sibirisk Lærk | 650 |
| FY | Fyr | 520 |
| FT | Thermo Fyr | 420 |
| GR | Gran | 470 |
| AY | Ayous | 390 |
| RO | Robinie | 770 |
| EL | Elm | 680 |
| AP | Asp | 490 |

**Vægtberegning eksempel:**
- 100 lbm 20×40mm Sapelli lister
- Først beregn m³: (20 × 40 × 100) / 1.000.000 = 0,08 m³
- Sapelli vægt: 630 kg/m³
- Vægt = 0,08 × 630 = 50,4 kg

## Savsnit (Klingetykkelse)

Hvert snit mister materiale til savklingen:

| Savtype | Typisk savsnit |
|---------|----------------|
| Rundsav (standard) | 3-4mm |
| Rundsav (tyndt blad) | 2-3mm |
| Båndsav | 2-3mm |

**Standard savsnit i beregninger: 4mm** (konservativt estimat)

## Optimering af Længdevalg

Ved valg af pakker til et job, beregn hvor mange emner der kan skæres fra hver pakkelængde.

**Formel for antal emner:**
```
emner = floor(pakke_længde_mm / (emne_længde_mm + savsnit))
```

**Formel for spild:**
```
spild = pakke_længde - (emner × emne_længde) - ((emner - 1) × savsnit)
```

**Eksempel: 1,8m emner (1800mm), savsnit = 4mm**

| Pakke | Beregning | Emner | Spild | Spild/emne |
|-------|-----------|-------|-------|------------|
| 6,0m | floor(6000/1804) = 3 | 3 | 592mm | 197mm |
| 5,5m | floor(5500/1804) = 3 | 3 | 92mm | 31mm ★ |
| 3,8m | floor(3800/1804) = 2 | 2 | 196mm | 98mm |
| 2,5m | floor(2500/1804) = 1 | 1 | 700mm | 700mm |

**Vinder:** 5,5m pakke giver lavest spild per emne.

**Principper:**
- Kortere pakker der passer godt = mindre spild
- Længere pakker = mere fleksibilitet til fremtidige jobs
- Sammenlign altid spild per emne, ikke total spild

## Flækning/Ripsning (Breddeoptimering)

Brede brædder kan kløves til flere smallere lister.

**Formel:**
```
lister = floor(bræt_bredde_mm / (liste_bredde_mm + savsnit))
spild = bræt_bredde - (lister × liste_bredde) - ((lister - 1) × savsnit)
```

**Eksempel: 65mm lister fra 147mm bræt, savsnit = 4mm**
```
lister = floor(147 / 69) = 2 lister
spild = 147 - (2 × 65) - (1 × 4) = 13mm
```

**Udbytteberegning:**
```
udbytte_% = (emner × emne_længde × lister × liste_bredde) / (pakke_længde × bræt_bredde) × 100
```

## Krumning (Warp)

Krumning reduceres proportionalt ved afkortning.

**Formel:**
```
ny_krumning = original_krumning × (ny_længde / original_længde)
```

**Eksempel:**
- Emne: 3,0m med 10cm krumning
- Skæres til 1,5m
- Ny krumning: 10cm × (1,5 / 3,0) = 5cm

**Praktisk anvendelse:**
- Hvis et emne er for krumt til høvling, kan afkortning reducere krumningen
- Halvering af længden halverer krumningen
