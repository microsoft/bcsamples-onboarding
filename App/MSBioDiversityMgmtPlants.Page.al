page 70074171 MS_BioDiversityMgmtPlants
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
                field(Name; 'Name')
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a name of the plant';
                    Caption = 'Name';
                }
                field(Description; 'Description')
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the plant';
                    Caption = 'Description';
                }
                field(IsPollinator; 'Is Pollinator')
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if this plant acts as a pollinator of other plants';
                    Caption = 'Is Pollinator';
                }
                field(PollinatedBy; 'Pollinated By')
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies what pollinates this plant.';
                    Caption = 'Pollinated By';
                }
            }
        }
    }
}