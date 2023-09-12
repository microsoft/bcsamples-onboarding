table 70074175 MS_BioDiversityMgmtSetup
{
    Caption = 'Bio Diversity Management Setup';
    DataPerCompany = true;
    InherentEntitlements = RIMDX;
    InherentPermissions = RIMDX;

    fields
    {
        field(1; PrimaryKey; Code[20])
        {
            Description = 'Primary key of the table';
            DataClassification = SystemMetadata;
        }
        field(2; Enabled; Boolean)
        {
            Description = 'Specifies if the Bio Diversity solution is enabled';
            DataClassification = SystemMetadata;
        }
        field(3; SetupWizardBanner; Blob)
        {
            Description = 'Specifies the banner to be used in assisted setups.';
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