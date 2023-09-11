page 70074171 MSBioDiversityMgmtPlants
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = MS_BioDiversityMgmtPlant;
    UsageCategory = Lists;
    Caption = 'Plants';

    layout
    {
        area(Content)
        {
            // Sets the No., Name, Contact, and Phone No. fields in the Customer table to be displayed as columns in the list. 
            repeater(Group)
            {
                field(PlantCode; 'Plant Code')
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a unique identifier of the plant';
                    Caption = 'Plant Code';
                }
            }
        }
    }
}