page 50150 "Lot Inventory API"
{
    PageType = API;
    APIPublisher = 'mschristiansen';
    APIGroup = 'inventory';
    APIVersion = 'v1.0';
    EntityName = 'lotInventory';
    EntitySetName = 'lotInventory';
    EntityCaption = 'Lot Inventory';
    EntitySetCaption = 'Lot Inventory';
    SourceTable = "Lot No. Information";
    ODataKeyFields = SystemId;
    DelayedInsert = true;
    Extensible = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                    Editable = false;
                }
                field(itemDescription; ItemDescription)
                {
                    Caption = 'Item Description';
                    Editable = false;
                }
                field(lotNo; Rec."Lot No.")
                {
                    Caption = 'Lot No.';
                    Editable = false;
                }
                field(lotDescription; Rec.Description)
                {
                    Caption = 'Lot Description';
                    Editable = false;
                }
                field(certificateNumber; Rec."Certificate Number")
                {
                    Caption = 'Certificate Number';
                    Editable = false;
                }
                field(balHeight; Rec."BAL Height")
                {
                    Caption = 'BAL Height';
                    Editable = false;
                }
                field(balLengthInterval; Rec."BAL Length Interval")
                {
                    Caption = 'BAL Length Interval';
                    Editable = false;
                }
                field(balWidthInterval; Rec."BAL Width Interval")
                {
                    Caption = 'BAL Width Interval';
                    Editable = false;
                }
                field(binCode; BinCode)
                {
                    Caption = 'Bin Code';
                    Editable = false;
                }
                field(quantity; Quantity)
                {
                    Caption = 'Quantity';
                    Editable = false;
                }
                field(reservedQuantity; ReservedQuantity)
                {
                    Caption = 'Reserved Quantity';
                    Editable = false;
                }
                field(remainingQuantity; RemainingQuantity)
                {
                    Caption = 'Remaining Quantity';
                    Editable = false;
                }
                field(unitCost; UnitCost)
                {
                    Caption = 'Unit Cost';
                    Editable = false;
                }
                field(totalCost; TotalCost)
                {
                    Caption = 'Total Cost';
                    Editable = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.ReadIsolation := IsolationLevel::ReadCommitted;
    end;

    trigger OnAfterGetRecord()
    begin
        CalculateLotData();
    end;

    var
        ItemDescription: Text[100];
        BinCode: Code[20];
        Quantity: Decimal;
        ReservedQuantity: Decimal;
        RemainingQuantity: Decimal;
        UnitCost: Decimal;
        TotalCost: Decimal;

    local procedure CalculateLotData()
    var
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ReservationEntry: Record "Reservation Entry";
        BinContent: Record "Bin Content";
    begin
        // Get Item Description
        ItemDescription := '';
        if Item.Get(Rec."Item No.") then
            ItemDescription := Item.Description;

        // Calculate Quantity and Cost from Item Ledger Entries
        Quantity := 0;
        TotalCost := 0;
        ItemLedgerEntry.SetRange("Item No.", Rec."Item No.");
        ItemLedgerEntry.SetRange("Lot No.", Rec."Lot No.");
        ItemLedgerEntry.SetRange(Open, true);
        if ItemLedgerEntry.FindSet() then
            repeat
                Quantity += ItemLedgerEntry."Remaining Quantity";
                ItemLedgerEntry.CalcFields("Cost Amount (Actual)");
                TotalCost += ItemLedgerEntry."Cost Amount (Actual)";
            until ItemLedgerEntry.Next() = 0;

        // Calculate Unit Cost
        UnitCost := 0;
        if Quantity <> 0 then
            UnitCost := TotalCost / Quantity;

        // Calculate Reserved Quantity from Reservation Entries
        ReservedQuantity := 0;
        ReservationEntry.SetRange("Item No.", Rec."Item No.");
        ReservationEntry.SetRange("Lot No.", Rec."Lot No.");
        ReservationEntry.SetRange(Positive, false);
        if ReservationEntry.FindSet() then
            repeat
                ReservedQuantity += Abs(ReservationEntry."Quantity (Base)");
            until ReservationEntry.Next() = 0;

        // Calculate Remaining (Available) Quantity
        RemainingQuantity := Quantity - ReservedQuantity;
        if RemainingQuantity < 0 then
            RemainingQuantity := 0;

        // Get Bin Code (first bin where this lot is stored)
        BinCode := '';
        BinContent.SetRange("Item No.", Rec."Item No.");
        BinContent.SetRange("Lot No. Filter", Rec."Lot No.");
        BinContent.SetFilter(Quantity, '>0');
        if BinContent.FindFirst() then
            BinCode := BinContent."Bin Code";
    end;
}
