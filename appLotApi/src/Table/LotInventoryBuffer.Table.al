table 50100 "Lot Inventory Buffer"
{
    TableType = Temporary;
    Caption = 'Lot Inventory Buffer';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = SystemMetadata;
        }
        field(11; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            DataClassification = SystemMetadata;
        }
        field(12; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            DataClassification = SystemMetadata;
        }
        field(20; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            DataClassification = SystemMetadata;
        }
        field(21; "Lot Description"; Text[100])
        {
            Caption = 'Lot Description';
            DataClassification = SystemMetadata;
        }
        field(22; "Certificate Number"; Code[20])
        {
            Caption = 'Certificate Number';
            DataClassification = SystemMetadata;
        }
        field(23; "BAL Height"; Decimal)
        {
            Caption = 'BAL Height';
            DataClassification = SystemMetadata;
        }
        field(24; "BAL Length Interval"; Text[30])
        {
            Caption = 'BAL Length Interval';
            DataClassification = SystemMetadata;
        }
        field(25; "BAL Width Interval"; Text[30])
        {
            Caption = 'BAL Width Interval';
            DataClassification = SystemMetadata;
        }
        field(26; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = SystemMetadata;
        }
        field(30; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            DataClassification = SystemMetadata;
        }
        field(31; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = SystemMetadata;
        }
        field(40; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = SystemMetadata;
            DecimalPlaces = 0 : 5;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Item No.", "Lot No.", "Bin Code", "Location Code")
        {
        }
    }
}
