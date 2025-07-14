page 62402 "JURE Personal ID View Card"
{
    Caption = 'Personal ID View Card';
    PageType = Card;
    UsageCategory = None;
    SourceTable = "JURE Personal ID Checking";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    Editable = false;
                    ToolTip = 'Auto generated unique record code.';
                }
                field("Personal ID"; Rec."Personal ID")
                {
                    ApplicationArea = All;
                    Caption = 'Personal ID';
                    Editable = false;
                    ToolTip = 'Enter Personal ID you wish to check.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    Editable = false;
                    ToolTip = 'Personal ID checking result.';
                }
            }
        }
    }

}
