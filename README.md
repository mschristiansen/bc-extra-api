# Business Central Extra API

Custom API extensions for Microsoft Dynamics 365 Business Central, designed for integration with MCP servers and AI assistants.

## Lot Inventory API

A read-only API endpoint that exposes lot number information for inventory queries.

### Endpoint

```
https://api.businesscentral.dynamics.com/v2.0/{tenant}/{environment}/api/mschristiansen/inventory/v1.0/companies({companyId})/lotInventory
```

### Fields

| Field | Type | Description |
|-------|------|-------------|
| id | GUID | Unique identifier |
| itemNo | Code[20] | Item number |
| itemDescription | Text[100] | Item description |
| lotNo | Code[50] | Lot number |
| lotDescription | Text[100] | Lot description/notes |
| certificateNumber | Text | Certificate number |
| balHeight | Decimal | BAL Height |
| balLengthInterval | Text[30] | BAL Length Interval |
| balWidthInterval | Text[30] | BAL Width Interval |
| binCode | Code[20] | Bin code where lot is stored |
| quantity | Decimal | Current inventory quantity |
| reservedQuantity | Decimal | Reserved quantity |
| remainingQuantity | Decimal | Available quantity (quantity - reserved) |
| unitCost | Decimal | Unit cost (LCY) |
| totalCost | Decimal | Total cost |

### Example Queries

```http
# Get all lots for a specific item
GET .../lotInventory?$filter=itemNo eq 'ITEM001'

# Get details for a specific lot
GET .../lotInventory?$filter=lotNo eq 'LOT123'

# Get lots with available inventory
GET .../lotInventory?$filter=remainingQuantity gt 0

# Get lots in a specific bin
GET .../lotInventory?$filter=binCode eq 'BIN-A1'
```

### Use Cases

This API enables AI assistants to answer questions like:
- "How much of item X is in stock?"
- "What lots exist for item X?"
- "What's the cost of lot Y?"
- "Which bin is lot Y in?"
- "How much of lot Y is reserved?"
- "What's the certificate number for lot Y?"
- "What are the dimensions of lot Y?"

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

## Contributing

Please read the [contribution guidelines](https://github.com/microsoft/AL-Go/blob/main/Scenarios/Contribute.md) for AL-Go projects.
