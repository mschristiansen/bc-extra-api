page 50151 "Lot Reservations API"
{
    PageType = API;
    APIPublisher = 'mschristiansen';
    APIGroup = 'warehouseAgent';
    APIVersion = 'v1.0';
    Caption = 'lotReservations', Locked = true;
    EntityName = 'lotReservation';
    EntitySetName = 'lotReservations';
    SourceTable = "Lot Reservation Buffer";
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
                field(lotNo; Rec."Lot No.")
                {
                    Caption = 'lotNo', Locked = true;
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'locationCode', Locked = true;
                }
                field(sourceType; Rec."Source Type")
                {
                    Caption = 'sourceType', Locked = true;
                }
                field(sourceId; Rec."Source ID")
                {
                    Caption = 'sourceId', Locked = true;
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'quantity', Locked = true;
                }
                field(expectedDate; Rec."Expected Receipt Date")
                {
                    Caption = 'expectedDate', Locked = true;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        LoadLotReservations();
    end;

    local procedure LoadLotReservations()
    var
        ReservationEntry: Record "Reservation Entry";
        EntryNo: Integer;
        CurrentItemNo: Code[20];
        CurrentLotNo: Code[50];
        CurrentLocationCode: Code[10];
        CurrentSourceType: Integer;
        CurrentSourceID: Code[20];
        CurrentExpectedDate: Date;
        TotalQty: Decimal;
    begin
        EntryNo := 0;

        ReservationEntry.SetCurrentKey("Item No.", "Lot No.", "Location Code", "Source Type", "Source ID");
        ReservationEntry.SetFilter("Lot No.", '<>%1', '');
        if ReservationEntry.FindSet() then
            repeat
                // Check if this is a new group
                if (ReservationEntry."Item No." <> CurrentItemNo) or
                   (ReservationEntry."Lot No." <> CurrentLotNo) or
                   (ReservationEntry."Location Code" <> CurrentLocationCode) or
                   (ReservationEntry."Source Type" <> CurrentSourceType) or
                   (ReservationEntry."Source ID" <> CurrentSourceID) then begin

                    // Save previous group if we have data
                    if CurrentItemNo <> '' then begin
                        EntryNo += 1;
                        InsertReservationBuffer(EntryNo, CurrentItemNo, CurrentLotNo, CurrentLocationCode, CurrentSourceType, CurrentSourceID, TotalQty, CurrentExpectedDate);
                    end;

                    // Start new group
                    CurrentItemNo := ReservationEntry."Item No.";
                    CurrentLotNo := ReservationEntry."Lot No.";
                    CurrentLocationCode := ReservationEntry."Location Code";
                    CurrentSourceType := ReservationEntry."Source Type";
                    CurrentSourceID := ReservationEntry."Source ID";
                    CurrentExpectedDate := ReservationEntry."Expected Receipt Date";
                    TotalQty := 0;
                end;

                TotalQty += ReservationEntry.Quantity;

                // Keep the latest expected date for the group
                if ReservationEntry."Expected Receipt Date" > CurrentExpectedDate then
                    CurrentExpectedDate := ReservationEntry."Expected Receipt Date";
            until ReservationEntry.Next() = 0;

        // Don't forget the last group
        if CurrentItemNo <> '' then begin
            EntryNo += 1;
            InsertReservationBuffer(EntryNo, CurrentItemNo, CurrentLotNo, CurrentLocationCode, CurrentSourceType, CurrentSourceID, TotalQty, CurrentExpectedDate);
        end;
    end;

    local procedure InsertReservationBuffer(EntryNo: Integer; ItemNo: Code[20]; LotNo: Code[50]; LocationCode: Code[10]; SourceType: Integer; SourceID: Code[20]; Qty: Decimal; ExpectedDate: Date)
    begin
        Rec.Init();
        Rec."Entry No." := EntryNo;
        Rec."Item No." := ItemNo;
        Rec."Lot No." := LotNo;
        Rec."Location Code" := LocationCode;
        Rec."Source Type" := SourceType;
        Rec."Source ID" := SourceID;
        Rec.Quantity := Qty;
        Rec."Expected Receipt Date" := ExpectedDate;
        Rec.Insert();
    end;
}
