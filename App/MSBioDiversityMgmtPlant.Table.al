table 70074170 MS_BioDiversityMgmtPlant
{
    Caption = 'Bio Diversity Plant';
    DataPerCompany = true;

    fields
    {
        field(1; PrimaryKey; Code[20])
        {
            Description = 'Primary key of the table';
            DataClassification = SystemMetadata;
        }
        field(2; Enabled; Boolean)
        {
            Description = 'Specifies if the Shoe Management solution is enabled';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PrimaryKey; PrimaryKey)
        {
            Clustered = TRUE;
        }
    }
}