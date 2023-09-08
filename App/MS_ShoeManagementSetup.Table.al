table 70074175 MS_ShoeManagementSetup
{
    Caption = 'Shoe Management Setup';
    DataPerCompany = true;

    fields
    {
        field(1; PrimaryKey; Code[20])
        {
            Description = 'Primary key of the table';
        }
        field(2; Enabled; Boolean)
        {
            Description = 'Specifies if the Shoe Management solution is enabled';
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