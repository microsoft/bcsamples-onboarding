table 70074172 MS_BioDiversityMgmtPlantFamily
{
    Caption = 'Bio Diversity Plant Family';
    DataPerCompany = true;
    LookupPageId = 70074174;

    fields
    {
        field(1; FamilyCode; Code[50])
        {
            Description = 'This code specifies a unique identifier of the plant family';
            DataClassification = SystemMetadata;
        }
        field(2; "Name"; text[100])
        {
            Description = 'Specifies the name of the plant family';
            DataClassification = SystemMetadata;
        }
        field(3; "Description"; text[1000])
        {
            Description = 'Specifies the description of the plant family';
            DataClassification = SystemMetadata;
        }
        field(4; "Characteristics"; text[100])
        {
            Description = 'Specifies the description of the plant family';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PrimaryKey; FamilyCode)
        {
            Clustered = TRUE;
        }
    }
}