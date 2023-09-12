report 70074170 MS_BioDiversityPlant
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = DefaultLayout;
    Caption = 'Bio Diversity Tracking';

    dataset
    {
        dataitem(Plants; MS_BioDiversityMgmtPlant)
        {
            column(PlantCode; PlantCode)
            {
            }
            column(ReportedOccurencesLastyear; ReportedOccurencesLastyear)
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
        AboutTitle = 'Track Bio Diversity progress';
        AboutText = 'Here you can track you *bio diversity progress*. This list is focused on **plants**. Printing to an Excel layout let''s you create beautiful looking visualizations which you know and love in *Excel*, updated with fresh data when you print.';

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
        layout(DefaultLayout)
        {
            Type = Excel;
            LayoutFile = 'BioDiversityPlant.xlsx';
        }
    }

    var
        PlantCodeFilter: Code[30];
}