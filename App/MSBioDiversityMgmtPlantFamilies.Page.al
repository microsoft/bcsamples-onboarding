page 70074174 MS_BioDivMgmtPlantFamilies
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = MS_BioDiversityMgmtPlantFamily;
    UsageCategory = Lists;
    Caption = 'Plant Families';
    AboutTitle = 'Plant families';
    AboutText = 'Here you create the plant families your plants belong to.';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(PlantCode; Rec.FamilyCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a unique identifier of the plant family';
                    Caption = 'Family Code';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a name of the plant family';
                    Caption = 'Name';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the plant family';
                    Caption = 'Description';
                }
                field(Characteristics; Rec.Characteristics)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies characteristics of the plant family';
                    Caption = 'Characteristics';
                }
            }
        }
    }
    actions
    {
        area(Reporting)
        {
            action("Top Plants")
            {
                Image = AnalysisView;
                ApplicationArea = All;
                RunObject = query MS_BioDiversityMgmtPlants;
                Tooltip = 'Open the Plants query in analysis mode.';
                AboutTitle = 'Analyse top plants';
                AboutText = 'Here you can analyse and pivot on plant data, to get a sense of the progress you are making on plants. There is a similar analysis option available If you are looking for [Insects](?page=70074172 "Opens the Insects page").';

                trigger OnAction();
                begin

                end;
            }
        }
    }
}