codeunit 70074176 MS_BioDiversityMgmtSetupList
{
    trigger OnRun()
    var
        BioDiversitySetup: Record MS_BioDiversityMgmtSetup;
        GuidedExperience: Codeunit "Guided Experience";
        SetupKey: Code[20];
        HttpClient: HttpClient;
        ResponseMsg: HttpResponseMessage;
        OutStream: OutStream;
        InStream: InStream;
    begin
        //First, enable the overall setup of the module
        SetupKey := 'BIODIVSETUP';
        if not BioDiversitySetup.Get(SetupKey) then begin
            BioDiversitySetup.Init();
            BioDiversitySetup.PrimaryKey := SetupKey;
            BioDiversitySetup.Enabled := true;
            BioDiversitySetup.Insert();
            Commit();
        end;


        if HttpClient.Get('https://github.com/microsoft/bcsamples-onboarding/tree/main/Media/Resources/wizardbanner.png', ResponseMsg) then begin
            ResponseMsg.Content.ReadAs(InStream);
            BioDiversitySetup.SetupWizardBanner.CreateOutStream(OutStream);
            CopyStream(OutStream, InStream);
            BioDiversitySetup.Modify();
            Commit();
        end;

        GuidedExperience.OpenAssistedSetup(Enum::"Assisted Setup Group"::MS_BioDiversity);
    end;
}

