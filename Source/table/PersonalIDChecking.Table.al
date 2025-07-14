table 62400 "JURE Personal ID Checking"
{
    Caption = 'Personal ID Checking';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "No."; Code[3])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code';
        }
        field(20; "Personal ID"; Code[11])
        {
            DataClassification = ToBeClassified;
            Caption = 'Personal ID';
        }
        field(30; Status; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Status';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
