page 62400 "JUREPersonal ID Checking List"
{
    Caption = 'Personal ID Checking List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "JURE Personal ID Checking";
    Editable = false;
    CardPageId = "JURE Personal ID View Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the check atempt.';
                }
                field("Personal ID"; Rec."Personal ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies entered Personal ID';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies personal ID validation result';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
    actions
    {
        area(Promoted)
        {
            actionref(OpenPageCardRef; OpenPageCard)
            {
            }
        }
        area(Creation)
        {
            action(OpenPageCard)
            {
                ApplicationArea = All;
                Caption = 'Open Page Card';
                ToolTip = 'Opens Page Card for adding new records.';
                Image = Add;
                RunObject = Page "JURE Personal ID Checking Card";
            }
        }
    }
}
