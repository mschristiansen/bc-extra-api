# Forsendelse Status

Spor forsendelser via online-book.dk ved at bruge et af følgende link-formater.

## Opslagstyper

| Søgetype | Format | Eksempel |
|----------|--------|----------|
| Fragtnr. | 8 cifre | 66691051 |
| TTnr. (Track & Trace) | 23 cifre | 66687416746714906600013 |
| Ref1/ordrenr. | SO + 4 cifre | SO4088 |

## Sporingslinks

### Søg på Fragtnr.
```
https://online-book.dk/link/?id=8741055052054055049052057048167054054&t=fr&n={fragtnummer}
```
Eksempel: `https://online-book.dk/link/?id=8741055052054055049052057048167054054&t=fr&n=66691051`

### Søg på TTnr. (Track & Trace)
```
https://online-book.dk/link/?id=8741055052054055049052057048167054054&t=tt&n={ttnummer}
```
Eksempel: `https://online-book.dk/link/?id=8741055052054055049052057048167054054&t=tt&n=66687416746714906600013`

### Søg på Ref1/ordrenr. (Salgsordrenummer)
```
https://online-book.dk/link/?id=8741055052054055049052057048167054054&t=r1&n={ordrenummer}
```
Eksempel: `https://online-book.dk/link/?id=8741055052054055049052057048167054054&t=r1&n=SO4088`

## Brug

Erstat `{fragtnummer}`, `{ttnummer}` eller `{ordrenummer}` med det aktuelle nummer for at få forsendelsens status.

## Programmatisk Hentning

For at hente data direkte (uden HTML frames), brug `/link/vis.asp` endpoint:

```
https://online-book.dk/link/vis.asp?id=8741055052054055049052057048167054054&t={type}&n={nummer}
```

Hvor `t` er:
- `fr` for Fragtnr.
- `tt` for TTnr.
- `r1` for Ref1/ordrenr.

## Svarstruktur

Forsendelsesstatussen indeholder følgende information:

### Nøgleinformation
- **Fragtnr.** - Forsendelsesnummer (8 cifre)
- **Status** - Aktuel leveringsstatus
- **Godkendt** - Dato og tid for godkendelse

### Parter
- **Afsender** - Navn og adresse
- **Modtager** - Navn og adresse

### Godsdetaljer
- **Varebeskrivelse** - Beskrivelse af indhold
- **Vægt** - Vægt i kg
- **Volumen** - Volumen i m³
- **Mål** - Længde × Bredde × Højde
- **Antal kolli** - Antal pakker/enheder

### Sporingshistorik

Tidslinjen viser hændelser i kronologisk rækkefølge:

| Hændelse | Beskrivelse |
|----------|-------------|
| Dokumentation indsendt | Forsendelsen er registreret |
| Forsendelse planlagt | Forsendelsen er booket |
| Terminal modtaget | Ankommet til terminal |
| Læsset til udbringning | På vej ud til levering |
| Leveret, signeret af [navn] | Leveret og modtaget |

### Typiske Statusværdier
- **Leveret med underskrift** - Forsendelsen er afleveret og kvitteret
- **Under transport** - Forsendelsen er undervejs
- **Terminal modtaget** - Venter på næste transport
- **Planlagt** - Forsendelsen er booket men ikke afhentet
