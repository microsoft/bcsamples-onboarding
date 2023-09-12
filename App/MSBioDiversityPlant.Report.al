report 70074170 MS_BioDiversityPlant
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;
    Caption = 'Bio Diversity Plant';


    dataset
    {
        dataitem(Plants; MS_BioDiversityMgmtPlant)
        {
            column(PlantCode; PlantCode)
            {
            }
            column(Name; Name)
            {
            }
            column(Description; Description)
            {
            }
            column(IsPollinator; IsPollinator)
            {
            }
            column(PollinatedBy; PollinatedBy)
            {
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(PlantCode; PlantCodeFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'PlantCode Filter';
                        ToolTip = 'PlantCode Filter';
                    }
                }
            }
        }
    }

    rendering
    {
        layout(LayoutName)
        {
            Type = Excel;
            LayoutFile = 'BioDiversityPlant.xlsx';
        }
    }

    var
        PlantCodeFilter: Code[30];
}