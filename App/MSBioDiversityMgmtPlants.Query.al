query 70074170 MS_BioDiversityMgmtPlants
{
    QueryType = Normal;
    Caption = 'Top Plants';
    DataAccessIntent = ReadOnly;
    QueryCategory = 'Plants';
    OrderBy = descending(ReportedOccurencesLastyear);

    AboutTitle = 'Analyse Top Plants';
    AboutText = 'Here you see the top plants spotted in the wild. By default the view is sorted by **number of occurrences** in the last year. You can create additional analysis views for more insights. Click around!';

    elements
    {
        dataitem(DataItem1; MS_BioDiversityMgmtPlant)
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
            column(ReportedOccurencesLastyear; ReportedOccurencesLastyear)
            {
            }
        }
    }

}