page 50150 "Lot Inventory API"
{
    PageType = API;
    APIPublisher = 'mschristiansen';
    APIGroup = 'warehouseAgent';
    APIVersion = 'v1.0';
    Caption = 'lotInventory', Locked = true;
    EntityName = 'lotInventory';
    EntitySetName = 'lotInventory';
    SourceTable = "Lot Inventory Buffer";
    SourceTableTemporary = true;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    DelayedInsert = true;
    ODataKeyFields = "Entry No.";

    layout
    {
        area(Content)
        {
            repeater(Records)
            {
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'itemNo', Locked = true;
                }
                field(itemDescription; Rec."Item Description")
                {
                    Caption = 'itemDescription', Locked = true;
                }
                field(baseUnitOfMeasure; Rec."Base Unit of Measure")
                {
                    Caption = 'baseUnitOfMeasure', Locked = true;
                }
                field(lotNo; Rec."Lot No.")
                {
                    Caption = 'lotNo', Locked = true;
                }
                field(lotDescription; Rec."Lot Description")
                {
                    Caption = 'lotDescription', Locked = true;
                }
                field(certificateNumber; Rec."Certificate Number")
                {
                    Caption = 'certificateNumber', Locked = true;
                }
                field(balHeight; Rec."BAL Height")
                {
                    Caption = 'balHeight', Locked = true;
                }
                field(balLengthInterval; Rec."BAL Length Interval")
                {
                    Caption = 'balLengthInterval', Locked = true;
                }
                field(balWidthInterval; Rec."BAL Width Interval")
                {
                    Caption = 'balWidthInterval', Locked = true;
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'blocked', Locked = true;
                }
                field(binCode; Rec."Bin Code")
                {
                    Caption = 'binCode', Locked = true;
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'locationCode', Locked = true;
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'quantity', Locked = true;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        LoadLotInventory();
    end;

    local procedure LoadLotInventory()
    var
        WarehouseEntry: Record "Warehouse Entry";
        Item: Record Item;
        LotNoInfo: Record "Lot No. Information";
        EntryNo: Integer;
        CurrentItemNo: Code[20];
        CurrentLotNo: Code[50];
        CurrentBinCode: Code[20];
        CurrentLocationCode: Code[10];
        CurrentVariantCode: Code[10];
        TotalQty: Decimal;
    begin
        EntryNo := 0;

        WarehouseEntry.SetCurrentKey("Item No.", "Lot No.", "Bin Code", "Location Code");
        WarehouseEntry.SetFilter("Lot No.", '<>%1', '');
        if WarehouseEntry.FindSet() then
            repeat
                // Check if this is a new group
                if (WarehouseEntry."Item No." <> CurrentItemNo) or
                   (WarehouseEntry."Lot No." <> CurrentLotNo) or
                   (WarehouseEntry."Bin Code" <> CurrentBinCode) or
                   (WarehouseEntry."Location Code" <> CurrentLocationCode) then begin

                    // Save previous group if quantity > 0
                    if (CurrentItemNo <> '') and (TotalQty > 0) then begin
                        EntryNo += 1;
                        InsertBufferRecord(EntryNo, CurrentItemNo, CurrentLotNo, CurrentBinCode, CurrentLocationCode, CurrentVariantCode, TotalQty);
                    end;

                    // Start new group
                    CurrentItemNo := WarehouseEntry."Item No.";
                    CurrentLotNo := WarehouseEntry."Lot No.";
                    CurrentBinCode := WarehouseEntry."Bin Code";
                    CurrentLocationCode := WarehouseEntry."Location Code";
                    CurrentVariantCode := WarehouseEntry."Variant Code";
                    TotalQty := 0;
                end;

                TotalQty += WarehouseEntry.Quantity;
            until WarehouseEntry.Next() = 0;

        // Don't forget the last group
        if (CurrentItemNo <> '') and (TotalQty > 0) then begin
            EntryNo += 1;
            InsertBufferRecord(EntryNo, CurrentItemNo, CurrentLotNo, CurrentBinCode, CurrentLocationCode, CurrentVariantCode, TotalQty);
        end;
    end;

    local procedure InsertBufferRecord(EntryNo: Integer; ItemNo: Code[20]; LotNo: Code[50]; BinCode: Code[20]; LocationCode: Code[10]; VariantCode: Code[10]; Qty: Decimal)
    var
        Item: Record Item;
        LotNoInfo: Record "Lot No. Information";
    begin
        Rec.Init();
        Rec."Entry No." := EntryNo;
        Rec."Item No." := ItemNo;
        Rec."Lot No." := LotNo;
        Rec."Bin Code" := BinCode;
        Rec."Location Code" := LocationCode;
        Rec.Quantity := Qty;

        // Get Item information
        if Item.Get(ItemNo) then begin
            Rec."Item Description" := Item.Description;
            Rec."Base Unit of Measure" := Item."Base Unit of Measure";
        end;

        // Get Lot No. Information
        if LotNoInfo.Get(ItemNo, VariantCode, LotNo) then begin
            Rec."Lot Description" := LotNoInfo.Description;
            Rec."Certificate Number" := LotNoInfo."Certificate Number";
            Rec."BAL Height" := LotNoInfo."BAL Height";
            Rec."BAL Length Interval" := LotNoInfo."BAL Length Interval";
            Rec."BAL Width Interval" := LotNoInfo."BAL Width Interval";
            Rec.Blocked := LotNoInfo.Blocked;
        end;

        Rec.Insert();
    end;
}
