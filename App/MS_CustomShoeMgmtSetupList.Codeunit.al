codeunit 70074176 MS_CustomShoeMgmtSetupList
{

    trigger OnRun()
    var
        GuidedExperience: Codeunit "Guided Experience";

    begin
        GuidedExperience.OpenAssistedSetup(Enum::"Assisted Setup Group"::ShoeManagement);
    end;
}

