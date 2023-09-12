page 70074172 MS_BioDiversityMgmtInsects
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = MS_BioDiversityMgmtInsect;
    UsageCategory = Lists;
    Caption = 'Insects';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(PrimaryKey; Rec.PrimaryKey)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a unique identifier of the Insect';
                    Caption = 'Plant Code';
                }
            }
        }
    }
}