page 70074171 MS_BioDiversityMgmtPlants
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = MS_BioDiversityMgmtPlant;
    UsageCategory = Lists;
    Caption = 'Plants';
    AboutTitle = 'Track your plants';
    AboutText = 'Here you can track plants and how often they are spotted in the wild. Also remember to keep track of [Insects](?page=70074171 "Opens the Insects page").';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(PlantCode; Rec.PlantCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a unique identifier of the plant';
                    Caption = 'Plant Code';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a name of the plant';
                    Caption = 'Name';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the plant';
                    Caption = 'Description';
                }
                field(IsPollinator; Rec.IsPollinator)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if this plant acts as a pollinator of other plants';
                    Caption = 'Is Pollinator';
                }
                field(PollinatedBy; Rec.PollinatedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies what pollinates this plant.';
                    Caption = 'Pollinated By';
                }
                field(ReportedOccurencesLastyear; Rec.ReportedOccurencesLastyear)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how often this plant was reported spotted in nature last year.';
                    Caption = 'Reported Occurrences';
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