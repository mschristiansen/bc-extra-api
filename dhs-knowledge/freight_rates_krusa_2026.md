# Freight Rate Calculator - K. Hansen Transport A/S

**Origin:** DK-6340 Kruså (Dansk Hårdttræ Savværk A/S)  
**Valid:** 2026-01-01 to 2026-12-31  
**Carrier:** K. Hansen Transport A/S, Park Alle 20, DK-6600 Vejen

## Terms

| Parameter | Value |
|-----------|-------|
| Booking deadline | 12:00 (noon) |
| Pickup window | 15:00 - 16:00 |
| Delivery term | Day-to-day |
| Payment terms | Net +15 days |
| Notice period | 1 month |

## Important Notes

- All base prices are in DKK
- **Road tax (Vejafgift): 7.5%** — applied to base price
- **Diesel surcharge (Dieseltillæg): 30%** — applied to base price
- Current diesel surcharge info: http://kht.dk/profil/diesel-og-miljoetillaeg/
- Islands without fixed bridge connection: price applies to shipping port (except Bornholm)
- All transport follows K. Hansen Transport's business terms

## Final Price Calculation

```
finalPrice = basePrice × (1 + vejafgift + dieseltillæg)
finalPrice = basePrice × (1 + 0.075 + 0.30)
finalPrice = basePrice × 1.375
```

**Note:** Surcharges (dangerous goods, time-definite, etc.) are added to base price before applying vejafgift and dieseltillæg.

---

## Zone Mapping (Denmark)

To calculate freight, first determine the destination zone from the postal code.

| Zone | Postal Code Ranges |
|------|-------------------|
| 1 | 6000-6799 |
| 2 | 5000-5899, 6800-7499, 8000-8399, 8600-8799 |
| 3 | 5900-5999, 7500-7699, 7800-7899, 8400-8599, 8800-8999, 9500-9699 |
| 4 | 7700-7799, 7900-7999, 9000-9499, 9700-9999 |
| 5 | 1000-3699, 3800-4999 |

### Zone Lookup Algorithm

```
function getZone(postalCode):
    code = parseInt(postalCode)
    
    if 6000 <= code <= 6799: return 1
    
    if 5000 <= code <= 5899: return 2
    if 6800 <= code <= 7499: return 2
    if 8000 <= code <= 8399: return 2
    if 8600 <= code <= 8799: return 2
    
    if 5900 <= code <= 5999: return 3
    if 7500 <= code <= 7699: return 3
    if 7800 <= code <= 7899: return 3
    if 8400 <= code <= 8599: return 3
    if 8800 <= code <= 8999: return 3
    if 9500 <= code <= 9699: return 3
    
    if 7700 <= code <= 7799: return 4
    if 7900 <= code <= 7999: return 4
    if 9000 <= code <= 9499: return 4
    if 9700 <= code <= 9999: return 4
    
    if 1000 <= code <= 3699: return 5
    if 3800 <= code <= 4999: return 5
    
    return null  // Not covered
```

---

## Pallet Rates (DKK per pallet)

### Quarter Pallets (1/4)

**Specifications:** 60 × 40 cm, max 200 kg, max height 1.2 m

| Quantity | Zone 1 | Zone 2 | Zone 3 | Zone 4 | Zone 5 |
|----------|--------|--------|--------|--------|--------|
| 1+ | 150 | 171 | 192 | 216 | 251 |

### Half Pallets (1/2)

**Specifications:** 80 × 60 cm, max 400 kg, max height 1.6 m

| Quantity | Zone 1 | Zone 2 | Zone 3 | Zone 4 | Zone 5 |
|----------|--------|--------|--------|--------|--------|
| 1+ | 179 | 200 | 222 | 251 | 292 |

### Full Pallets (1/1)

**Specifications:** 120 × 80 cm, max 1000 kg, max height 2.4 m

| Quantity | Zone 1 | Zone 2 | Zone 3 | Zone 4 | Zone 5 |
|----------|--------|--------|--------|--------|--------|
| 1 | 263 | 292 | 342 | 356 | 470 |
| 2-4 | 227 | 263 | 275 | 308 | 427 |
| 5-10 | 164 | 179 | 179 | 221 | 284 |
| 11-15 | 136 | 150 | 169 | 200 | 278 |
| 16-20 | 109 | 120 | 161 | 181 | 271 |
| 21-25 | 91 | 100 | 134 | 150 | 225 |
| 26+ | 75 | 83 | 112 | 125 | 188 |

### Full Truck Load (FTL)

**Per shipment (not per pallet)**

| Zone 1 | Zone 2 | Zone 3 | Zone 4 | Zone 5 |
|--------|--------|--------|--------|--------|
| 2276 | 2503 | 3356 | 3754 | 5632 |

### Pallet Rate Calculation Algorithm

```
function getFullPalletRate(quantity, zone):
    rates = {
        1: [263, 292, 342, 356, 470],
        2: [227, 263, 275, 308, 427],
        5: [164, 179, 179, 221, 284],
        11: [136, 150, 169, 200, 278],
        16: [109, 120, 161, 181, 271],
        21: [91, 100, 134, 150, 225],
        26: [75, 83, 112, 125, 188]
    }
    
    if quantity >= 26: tier = 26
    else if quantity >= 21: tier = 21
    else if quantity >= 16: tier = 16
    else if quantity >= 11: tier = 11
    else if quantity >= 5: tier = 5
    else if quantity >= 2: tier = 2
    else: tier = 1
    
    return rates[tier][zone - 1] * quantity
```

---

## General Cargo (Stykgods) Rates

**Pricing:** Per shipment, based on chargeable weight

| Weight (kg) | Zone 1 | Zone 2 | Zone 3 | Zone 4 | Zone 5 |
|-------------|--------|--------|--------|--------|--------|
| ≤ 20 | 118 | 126 | 127 | 131 | 134 |
| ≤ 50 | 159 | 175 | 187 | 189 | 197 |
| ≤ 100 | 232 | 261 | 274 | 284 | 291 |
| ≤ 150 | 275 | 348 | 365 | 374 | 409 |
| ≤ 200 | 374 | 432 | 456 | 473 | 489 |
| ≤ 250 | 403 | 481 | 503 | 630 | 637 |
| ≤ 300 | 484 | 576 | 591 | 731 | 755 |
| ≤ 400 | 539 | 621 | 670 | 852 | 889 |
| ≤ 500 | 609 | 712 | 805 | 929 | 991 |

### Volumetric Weight Rules

Charges are based on the **higher** of actual weight or volumetric weight.

| Conversion | Formula |
|------------|---------|
| Cubic meters | 1 m³ = 250 kg chargeable weight |
| Loading meters | 1 ldm = 1500 kg chargeable weight |

### Chargeable Weight Algorithm

```
function getChargeableWeight(actualWeightKg, lengthM, widthM, heightM):
    volumeM3 = lengthM * widthM * heightM
    volumetricWeight = volumeM3 * 250
    return max(actualWeightKg, volumetricWeight)

function getChargeableWeightFromLdm(actualWeightKg, loadingMeters):
    ldmWeight = loadingMeters * 1500
    return max(actualWeightKg, ldmWeight)
```

---

## Parcel Rates (GLS Denmark)

**Handled by KHT:** Parcels are collected by KHT and delivered to GLS in the evening. Customer service handled by KHT.

### Parcel Constraints

- Max circumference + length: 3.0 m
- Max length: 2.0 m
- Must comply with GLS parcel conditions (deviations may incur extra costs)

### Rates (DKK per parcel)

| Delivery Type | 0-1 kg | 1-5 kg | 5-10 kg | 10-15 kg | 15-20 kg | 20-25 kg | 25-30 kg |
|---------------|--------|--------|---------|----------|----------|----------|----------|
| Business (Erhverv) | 77 | 77 | 77 | 83 | 83 | 96 | 96 |
| Private (Privat) | 92 | 92 | 96 | 99 | 99 | 110 | 110 |
| Parcel Shop (Pakkeshop) | 77 | 77 | 77 | 83 | 83 | — | — |

**Note:** Parcel shop delivery max weight is 20 kg.

---

## Surcharges

| Service | Unit | Price (DKK) |
|---------|------|-------------|
| Pallet exchange fee | Per pallet | 12.50 |
| Dangerous goods (ADR) | Per shipment | 135 |
| Time-definite before 10:00 | Per shipment | 958 |
| Time-definite before 12:00 | Per shipment | 739 |
| Ferry/airport fee | Per shipment | 150 |
| Restante fee | Per shipment | 155 |
| Delivery with tail-lift truck | Per shipment | +15% |

**Note:** Tail-lift delivery is according to weekly schedule.

## Mandatory Taxes (Applied to All Shipments)

| Tax | Rate | Description |
|-----|------|-------------|
| Vejafgift (Road tax) | 7.5% | Applied to base price |
| Dieseltillæg (Diesel surcharge) | 30% | Applied to base price |
| **Combined multiplier** | **× 1.375** | Multiply base price to get final price |

---

## Complete Calculation Examples

### Example 1: 8 full pallets to Copenhagen (1000)

```
Postal code: 1000 → Zone 5
Pallet type: Full (1/1)
Quantity: 8 → Tier 5-10
Rate: 284 DKK/pallet
Base price: 8 × 284 = 2,272 DKK
Vejafgift (7.5%): 2,272 × 0.075 = 170.40 DKK
Dieseltillæg (30%): 2,272 × 0.30 = 681.60 DKK
Total: 2,272 + 170.40 + 681.60 = 3,124 DKK
(or: 2,272 × 1.375 = 3,124 DKK)
```

### Example 2: 3 half pallets to Odense (5000)

```
Postal code: 5000 → Zone 2
Pallet type: Half (1/2)
Quantity: 3
Rate: 200 DKK/pallet
Base price: 3 × 200 = 600 DKK
Total: 600 × 1.375 = 825 DKK
```

### Example 3: 75 kg cargo to Aalborg (9000)

```
Postal code: 9000 → Zone 4
Weight: 75 kg → Tier ≤100
Base price: 284 DKK
Total: 284 × 1.375 = 390.50 DKK
```

### Example 4: Business parcel 12 kg to anywhere in Denmark

```
Weight: 12 kg → Tier 10-15 kg
Type: Business
Base price: 83 DKK
Total: 83 × 1.375 = 114.13 DKK
```

### Example 5: 5 full pallets to Aarhus (8000) with dangerous goods

```
Postal code: 8000 → Zone 2
Pallet type: Full (1/1)
Quantity: 5 → Tier 5-10
Rate: 179 DKK/pallet
Pallet base: 5 × 179 = 895 DKK
Dangerous goods surcharge: 135 DKK
Base price: 895 + 135 = 1,030 DKK
Total: 1,030 × 1.375 = 1,416.25 DKK
```

---

## JSON Data Structure for Programmatic Use

```json
{
  "origin": {"postalCode": "6340", "city": "Kruså"},
  "validFrom": "2026-01-01",
  "validTo": "2026-12-31",
  "taxes": {
    "vejafgift": 0.075,
    "dieseltillaeg": 0.30,
    "totalMultiplier": 1.375
  },
  "zones": {
    "1": ["6000-6799"],
    "2": ["5000-5899", "6800-7499", "8000-8399", "8600-8799"],
    "3": ["5900-5999", "7500-7699", "7800-7899", "8400-8599", "8800-8999", "9500-9699"],
    "4": ["7700-7799", "7900-7999", "9000-9499", "9700-9999"],
    "5": ["1000-3699", "3800-4999"]
  },
  "palletRates": {
    "quarter": {"spec": "60x40cm, max200kg, maxH1.2m", "rates": {"1+": [150,171,192,216,251]}},
    "half": {"spec": "80x60cm, max400kg, maxH1.6m", "rates": {"1+": [179,200,222,251,292]}},
    "full": {
      "spec": "120x80cm, max1000kg, maxH2.4m",
      "rates": {
        "1": [263,292,342,356,470],
        "2-4": [227,263,275,308,427],
        "5-10": [164,179,179,221,284],
        "11-15": [136,150,169,200,278],
        "16-20": [109,120,161,181,271],
        "21-25": [91,100,134,150,225],
        "26+": [75,83,112,125,188]
      }
    },
    "ftl": [2276,2503,3356,3754,5632]
  },
  "cargoRates": {
    "20": [118,126,127,131,134],
    "50": [159,175,187,189,197],
    "100": [232,261,274,284,291],
    "150": [275,348,365,374,409],
    "200": [374,432,456,473,489],
    "250": [403,481,503,630,637],
    "300": [484,576,591,731,755],
    "400": [539,621,670,852,889],
    "500": [609,712,805,929,991]
  },
  "volumetricConversion": {"m3ToKg": 250, "ldmToKg": 1500},
  "parcelRates": {
    "business": {"1":77,"5":77,"10":77,"15":83,"20":83,"25":96,"30":96},
    "private": {"1":92,"5":92,"10":96,"15":99,"20":99,"25":110,"30":110},
    "parcelShop": {"1":77,"5":77,"10":77,"15":83,"20":83}
  },
  "surcharges": {
    "palletExchange": 12.5,
    "dangerousGoods": 135,
    "timeBefore10": 958,
    "timeBefore12": 739,
    "ferryAirport": 150,
    "restante": 155,
    "tailLift": 0.15
  }
}
```
