page 70074173 MS_BioDiversityMgmtSetup
{
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = MS_BioDiversityMgmtSetup;
    ApplicationArea = All;
    Caption = 'Bio Diversity Setup';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(SetupWizardBanner; Rec.SetupWizardBanner)
                {
                    ToolTip = 'This is our banner we use in steup wizards.';
                    ApplicationArea = All;

                }
            }
        }

    }
    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(SetupWizardBanner);
    end;
}