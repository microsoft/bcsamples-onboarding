table 70074170 MS_BioDiversityMgmtPlant
{
    Caption = 'Bio Diversity Plant';
    DataPerCompany = true;

    fields
    {
        field(1; PlantCode; Code[30])
        {
            Description = 'This code specifies a unique identifier of the plant';
            DataClassification = SystemMetadata;
        }
        field(2; "Name"; text[100])
        {
            Description = 'Specifies if name of the plant';
            DataClassification = SystemMetadata;
        }
        field(3; "Description"; text[1000])
        {
            Description = 'Specifies if description of the plant';
            DataClassification = SystemMetadata;
        }
        field(4; IsPollinator; Boolean)
        {
            Description = 'Specifies if this plant acts as a pollinator for other plants';
            DataClassification = SystemMetadata;
        }
        field(5; PollinatedBy; Enum MS_BioDiversityMgmtPollinator)
        {
            Description = 'Specifies how the plant is pollinated';
            DataClassification = SystemMetadata;
        }
        field(6; ReportedOccurencesLastyear; Integer)
        {
            Description = 'Specifies how often the plant has been reported spotted in nature the last year.';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PrimaryKey; PlantCode)
        {
            Clustered = TRUE;
        }
    }
}