# Business Central Extra API

Custom API extensions for Microsoft Dynamics 365 Business Central, designed for integration with MCP servers and AI assistants.

## APIs

This extension provides two read-only API endpoints for warehouse/inventory queries:

| API | Purpose |
|-----|---------|
| `lotInventory` | Lot-level inventory by bin location |
| `lotReservations` | Reservations on lot numbers |

### API Configuration

- **Publisher:** `mschristiansen`
- **Group:** `warehouseAgent`
- **Version:** `v1.0`

### Endpoint URLs

```
https://api.businesscentral.dynamics.com/v2.0/{tenant}/{environment}/api/mschristiansen/warehouseAgent/v1.0/companies({companyId})/lotInventory

https://api.businesscentral.dynamics.com/v2.0/{tenant}/{environment}/api/mschristiansen/warehouseAgent/v1.0/companies({companyId})/lotReservations
```

## Lot Inventory API

Returns one row per (lot, bin) combination with inventory quantity > 0.

### Fields

| Field | Type | Filterable | Description |
|-------|------|------------|-------------|
| itemNo | Code[20] | ✅ | Item number |
| itemDescription | Text[100] | ❌ | Item description |
| lotNo | Code[50] | ✅ | Lot number |
| lotDescription | Text[100] | ❌ | Lot description/notes |
| certificateNumber | Code[20] | ❌ | FSC certificate number |
| balHeight | Decimal | ❌ | Thickness in mm |
| balLengthInterval | Text[30] | ❌ | Length interval |
| balWidthInterval | Text[30] | ❌ | Width interval |
| binCode | Code[20] | ✅ | Storage bin location |
| locationCode | Code[10] | ✅ | Location code |
| quantity | Decimal | ❌ | Aggregated inventory quantity |
| baseUnitOfMeasure | Code[10] | ❌ | Unit of measure (M3, M, STK) |
| blocked | Boolean | ❌ | True if lot is blocked/quarantined |

### Example Queries

```http
# Get all lots in a specific bin
GET .../lotInventory?$filter=binCode eq 'HAL5'

# Get lots for items starting with 'SA' (Sapelli)
GET .../lotInventory?$filter=startswith(itemNo, 'SA')

# Get details for a specific lot
GET .../lotInventory?$filter=lotNo eq '105427'
```

## Lot Reservations API

Shows reservations against lot numbers - what's reserved for sales orders, production orders, etc.

### Fields

| Field | Type | Filterable | Description |
|-------|------|------------|-------------|
| itemNo | Code[20] | ✅ | Item number |
| lotNo | Code[50] | ✅ | Lot number |
| locationCode | Code[10] | ✅ | Location code |
| sourceType | Integer | ✅ | Source table ID |
| sourceId | Code[20] | ❌ | Document number |
| quantity | Decimal | ❌ | Reserved quantity (negative = outbound) |
| expectedDate | Date | ❌ | Expected date |

### Source Types

| sourceType | Meaning |
|------------|---------|
| 37 | Sales Line |
| 5406 | Prod. Order Line |
| 5407 | Prod. Order Component |
| 32 | Item Ledger Entry |

### Example Queries

```http
# Get reservations for a specific lot
GET .../lotReservations?$filter=lotNo eq '105427'

# Get all sales order reservations
GET .../lotReservations?$filter=sourceType eq 37
```

## Use Cases

These APIs enable AI assistants to answer questions like:
- "What lots do we have of Sapelli?"
- "What's in Hal 5?"
- "Is lot 105427 reserved?"
- "How much is actually available after reservations?"
- "Is this lot blocked?"
- "What are the dimensions of this lot?"

## Implementation Notes

The APIs use Page-based implementation with temporary buffer tables (not Query-based) for compatibility with BC MCP servers. Data is aggregated in `OnOpenPage`:

- **lotInventory**: Aggregates `Warehouse Entry` by item/lot/bin/location, joins to `Item` and `Lot No. Information`
- **lotReservations**: Aggregates `Reservation Entry` by item/lot/location/source

## Dependencies

This extension requires:
- **DHS - Basis** (v1.0.0.17) by Aktieselskabet balance.as

## Development

This project uses AL-Go for GitHub Actions-based CI/CD.

### Local Development

```powershell
# Create local Docker-based dev environment
.\.AL-Go\localDevEnv.ps1

# Create cloud-based Business Central Sandbox
.\.AL-Go\cloudDevEnv.ps1
```

### Build & Deploy

All builds run through GitHub Actions. Push to main, release/*, or feature/* branches to trigger the CI/CD pipeline.

## Project Structure

```
appLotApi/
  src/
    Page/
      LotInventoryAPI.Page.al      # Lot inventory API endpoint
      LotReservationsAPI.Page.al   # Lot reservations API endpoint
    Table/
      LotInventoryBuffer.Table.al  # Temporary buffer for inventory
      LotReservationBuffer.Table.al # Temporary buffer for reservations
  app.json                         # App manifest
```

## Contributing

Please read the [contribution guidelines](https://github.com/microsoft/AL-Go/blob/main/Scenarios/Contribute.md) for AL-Go projects.
