query 50150 "Lot Inventory API"
{
    QueryType = API;
    APIPublisher = 'mschristiansen';
    APIGroup = 'inventory';
    APIVersion = 'v1.0';
    Caption = 'lotInventory', Locked = true;
    EntityName = 'lotInventory';
    EntitySetName = 'lotInventory';

    elements
    {
        dataitem(WarehouseEntry; "Warehouse Entry")
        {
            column(itemNo; "Item No.")
            {
                Caption = 'itemNo', Locked = true;
            }
            column(lotNo; "Lot No.")
            {
                Caption = 'lotNo', Locked = true;
            }
            column(binCode; "Bin Code")
            {
                Caption = 'binCode', Locked = true;
            }
            column(locationCode; "Location Code")
            {
                Caption = 'locationCode', Locked = true;
            }
            column(quantity; Quantity)
            {
                Caption = 'quantity', Locked = true;
                Method = Sum;
                ColumnFilter = quantity = filter(>0);
            }
            dataitem(Item; Item)
            {
                DataItemLink = "No." = WarehouseEntry."Item No.";
                SqlJoinType = LeftOuterJoin;

                column(itemDescription; Description)
                {
                    Caption = 'itemDescription', Locked = true;
                }
                dataitem(LotNoInfo; "Lot No. Information")
                {
                    DataItemLink = "Item No." = WarehouseEntry."Item No.", "Variant Code" = WarehouseEntry."Variant Code", "Lot No." = WarehouseEntry."Lot No.";
                    SqlJoinType = LeftOuterJoin;

                    column(lotDescription; Description)
                    {
                        Caption = 'lotDescription', Locked = true;
                    }
                    column(certificateNumber; "Certificate Number")
                    {
                        Caption = 'certificateNumber', Locked = true;
                    }
                    column(balHeight; "BAL Height")
                    {
                        Caption = 'balHeight', Locked = true;
                    }
                    column(balLengthInterval; "BAL Length Interval")
                    {
                        Caption = 'balLengthInterval', Locked = true;
                    }
                    column(balWidthInterval; "BAL Width Interval")
                    {
                        Caption = 'balWidthInterval', Locked = true;
                    }
                }
            }
        }
    }
}
