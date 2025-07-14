page 62401 "JURE Personal ID Checking Card"
{
    Caption = 'Personal ID Checking Card';
    PageType = Card;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; GeneratedCode)
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                    Editable = false;
                    ToolTip = 'Auto generated unique record code.';
                }
                field("Personal ID"; PersonalID)
                {
                    ApplicationArea = All;
                    Caption = 'Personal ID';
                    ToolTip = 'Enter Personal ID you wish to check.';

                    trigger OnValidate()
                    begin
                        this.GetCode();
                        this.GetStatus();
                    end;
                }
                field(Status; CheckStatus)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    Editable = false;
                    ToolTip = 'Personal ID checking result.';
                }
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            actionref(SaveRecordRef; SaveRecord)
            {

            }
        }
        area(Creation)
        {
            action(SaveRecord)
            {
                ApplicationArea = All;
                Caption = 'Save Record';
                ToolTip = 'Saves the record to the database.';
                Image = New;

                trigger OnAction()
                var
                    PersonalIDChecking: Record "JURE Personal ID Checking";
                begin
                    PersonalIDChecking.Init();
                    PersonalIDChecking."No." := GeneratedCode;
                    PersonalIDChecking."Personal ID" := PersonalID;
                    PersonalIDChecking.Status := CheckStatus;
                    PersonalIDChecking.Insert();
                    Message('Record saved.');
                end;
            }
        }
    }

    var
        GeneratedCode: Code[3];
        PersonalID: Code[11];
        CheckStatus: Text[100];

    local procedure GetCode()
    var
        PersonalIDChecking: Record "JURE Personal ID Checking";
        LastCode: Code[10];
        NextNumber: Integer;
    begin
        PersonalIDChecking.SetCurrentKey("No.");
        if PersonalIDChecking.FindLast() then begin
            LastCode := PersonalIDChecking."No.";
            if not Evaluate(NextNumber, LastCode) then
                NextNumber := 1;
            NextNumber += 1;
        end else
            NextNumber := 1;

        GeneratedCode := Format(NextNumber, 3, '<Integer,3><Filler Character,0>');
    end;

    local procedure GetStatus()
    var
        i, sum, remainder, controlDigit: Integer;
        Weights1: array[10] of Integer;
        Weights2: array[10] of Integer;
        Digit: array[11] of Integer;
        Year, Month, Day: Integer;
        MaxDaysInMonth: Integer;
    begin
        // Initialize weight arrays
        Weights1[1] := 1; Weights1[2] := 2; Weights1[3] := 3; Weights1[4] := 4; Weights1[5] := 5;
        Weights1[6] := 6; Weights1[7] := 7; Weights1[8] := 8; Weights1[9] := 9; Weights1[10] := 1;

        Weights2[1] := 3; Weights2[2] := 4; Weights2[3] := 5; Weights2[4] := 6; Weights2[5] := 7;
        Weights2[6] := 8; Weights2[7] := 9; Weights2[8] := 1; Weights2[9] := 2; Weights2[10] := 3;

        // Check if exactly 11 digits
        if StrLen(PersonalID) <> 11 then begin
            CheckStatus := 'Invalid: Must be exactly 11 digits';
            exit;
        end;

        // Parse digits and validate they are numeric
        for i := 1 to 11 do
            if not IsNumeric(CopyStr(PersonalID, i, 1)) then begin
                CheckStatus := 'Invalid: Must contain only digits';
                exit;
            end else
                Evaluate(Digit[i], CopyStr(PersonalID, i, 1));

        // Special case: codes starting with 9 (no validation rules apply except 11 digits)
        if Digit[1] = 9 then begin
            CheckStatus := 'Valid (Special code starting with 9)';
            exit;
        end;

        // Validate first digit (century and gender indicator)
        if (Digit[1] < 1) or (Digit[1] > 6) then begin
            CheckStatus := 'Invalid: First digit must be 1-6 or 9';
            exit;
        end;

        // Extract birth date components
        Year := Digit[2] * 10 + Digit[3];
        case Digit[1] of
            1,2: Year := 1800 + Year;
            3,4: Year := 1900 + Year;
            5,6: Year := 2000 + Year;
        end;

        Month := Digit[4] * 10 + Digit[5];
        Day := Digit[6] * 10 + Digit[7];

        // Validate month
        if (Month < 1) or (Month > 12) then
            // Exception: month can be 00 for elderly people who don't remember birth month
            if Month <> 0 then begin
                CheckStatus := 'Invalid: Month must be 01-12 or 00';
                exit;
            end;


        // Validate day
        if Month = 0 then begin
            // Exception: day can be 00 when month is 00
            if (Day < 0) or (Day > 31) then begin
                CheckStatus := 'Invalid: Day must be 00-31 when month is 00';
                exit;
            end;
        end else begin
            // Normal day validation
            case Month of
                1,3,5,7,8,10,12: MaxDaysInMonth := 31;
                4,6,9,11: MaxDaysInMonth := 30;
                2:
                    // Leap year calculation
                    if (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0)) then
                        MaxDaysInMonth := 29
                    else
                        MaxDaysInMonth := 28;
            end;

            if (Day < 1) or (Day > MaxDaysInMonth) then begin
                CheckStatus := 'Invalid: Day out of range for the given month and year';
                exit;
            end;
        end;

        // Control digit calculation
        sum := 0;
        for i := 1 to 10 do
            sum += Digit[i] * Weights1[i];

        remainder := sum mod 11;
        if remainder <> 10 then
            controlDigit := remainder
        else begin
            // If remainder is 10, use second set of weights
            sum := 0;
            for i := 1 to 10 do
                sum += Digit[i] * Weights2[i];
            remainder := sum mod 11;
            if remainder <> 10 then
                controlDigit := remainder
            else
                controlDigit := 0;
        end;

        // Validate control digit
        if Digit[11] <> controlDigit then begin
            CheckStatus := 'Invalid: Control digit mismatch';
            exit;
        end;

        CheckStatus := 'Valid';
    end;

    local procedure IsNumeric(Value: Text[1]): Boolean
    var
        TestInt: Integer;
    begin
        exit(Evaluate(TestInt, Value));
    end;
}
