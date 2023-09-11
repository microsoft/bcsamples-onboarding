codeunit 70074176 MS_BioDiversityMgmtSetupList
{

    trigger OnRun()
    var
        GuidedExperience: Codeunit "Guided Experience";

    begin
        GuidedExperience.OpenAssistedSetup(Enum::"Assisted Setup Group"::MS_BioDiversity);
    end;
}

