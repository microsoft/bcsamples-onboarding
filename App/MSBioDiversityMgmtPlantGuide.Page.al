page 70074176 MS_BioDiversityMgmtPlantGuide
{
    Caption = 'Define the list of plants';
    PageType = NavigatePage;
    SourceTable = MS_BioDiversityMgmtPlant;
    SourceTableTemporary = true;
    ApplicationArea = All;
    Permissions = tabledata MS_BioDiversityMgmtPlant = ri;

    layout
    {
        area(content)
        {
            //group(StandardBanner)
            group(StandardBanner)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisible and not FinishActionEnabled;
                field(MediaResourcesStandard; MediaResourcesStandard."Media Reference")
                //field(BioDiversitySetup; BioDiversitySetup.SetupWizardBanner)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(CustomBanner)
            {
                Caption = '';
                Editable = false;
                Visible = CustomBannerVisible and not FinishActionEnabled;
                field(BioDiversitySetup; BioDiversitySetup.SetupWizardBanner)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(FinishedBanner)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisible and FinishActionEnabled;
                field(MediaResourcesDone; MediaResourcesDone."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }

            group(Step1)
            {
                Visible = Step1Visible;

                group("Welcome to PageName")
                {
                    Caption = 'Welcome to Bio Diversity Management Setup';
                    Visible = Step1Visible;

                    group(Group18)
                    {
                        Caption = '';
                        InstructionalText = 'Step1 - Import the list of plants.';
                    }
                }
                group("Let's go!")
                {
                    Caption = 'Let''s go!';
                    group(Group22)
                    {
                        Caption = '';
                        InstructionalText = 'When you click next we will import a list from Github of well known plants. You will get the chance to review the list before we store it in your system.';
                    }
                }
            }

            group(Step2)
            {
                Caption = '';
                InstructionalText = 'Step2 - Verify the list of plants.';
                Visible = Step2Visible;
                Editable = false;
                //You might want to add fields here
                group(Group24)
                {
                    Caption = '';
                    InstructionalText = 'Please verify that the list looks like you expect it. When you click next, we will store the list of plants your system. You can find it in the Plants page.';
                }
                repeater(TempPlants)
                {
                    field("Plant Name"; Rec.Name)
                    {
                        ToolTip = 'Name of the plant';
                    }
                    field("Plant Description"; Rec.Description)
                    {
                        ToolTip = 'Description of the plant';
                    }
                }
            }

            group(Step3)
            {
                Visible = Step3Visible;
                group(Group23)
                {
                    Caption = '';
                    InstructionalText = 'Congratulations! We are done with importing plants.';
                }
                group("That's it!")
                {
                    Caption = 'That''s it!';
                    group(Group25)
                    {
                        Caption = '';
                        InstructionalText = 'To close this setup, choose Finish.';
                    }
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(ActionBack)
            {
                ApplicationArea = All;
                Caption = 'Back';
                Enabled = BackActionEnabled;
                Image = PreviousRecord;
                InFooterBar = true;
                trigger OnAction();
                begin
                    NextStep(true);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = All;
                Caption = 'Next';
                Enabled = NextActionEnabled;
                Image = NextRecord;
                InFooterBar = true;
                trigger OnAction();
                begin
                    NextStep(false);
                end;
            }
            action(ActionFinish)
            {
                ApplicationArea = All;
                Caption = 'Finish';
                Enabled = FinishActionEnabled;
                Image = Approve;
                InFooterBar = true;
                trigger OnAction();
                begin
                    FinishAction();
                end;
            }
        }
    }

    trigger OnInit();
    begin
        LoadCustomBanner();
        LoadTopBanners();
    end;

    trigger OnOpenPage();
    var
    begin
        Step := Step::Start;
        EnableControls();
    end;

    var
        MediaRepositoryDone: Record "Media Repository";
        MediaRepositoryStandard: Record "Media Repository";
        MediaResourcesDone: Record "Media Resources";
        MediaResourcesStandard: Record "Media Resources";
        BioDiversitySetup: Record MS_BioDiversityMgmtSetup;

        Step: Option Start,Step2,Finish;
        BackActionEnabled: Boolean;
        FinishActionEnabled: Boolean;
        NextActionEnabled: Boolean;
        Step1Visible: Boolean;
        Step2Visible: Boolean;
        Step3Visible: Boolean;
        TopBannerVisible: Boolean;
        CustomBannerVisible: Boolean;

    local procedure EnableControls();
    begin
        ResetControls();

        case Step of
            Step::Start:
                ShowStep1();
            Step::Step2:
                ShowStep2();
            Step::Finish:
                ShowStep3();
        end;
    end;

    local procedure FinishAction();
    begin
        CurrPage.Close();
    end;

    local procedure NextStep(Backwards: Boolean);
    begin
        if Backwards then
            Step := Step - 1
        else
            Step := Step + 1;

        EnableControls();
    end;

    local procedure ShowStep1();
    begin
        Step1Visible := true;

        FinishActionEnabled := false;
        BackActionEnabled := false;
    end;

    local procedure ShowStep2();
    var
        Plants: JsonToken;
    begin
        Step2Visible := true;

        if not Rec.IsEmpty() then
            exit;

        Plants := LoadPlantsFromGitHub();
        LoadJsonResponseToTempTable(Plants);
    end;

    local procedure ShowStep3();
    begin
        FlushRecordsIntoDB();
        Step3Visible := true;

        NextActionEnabled := false;
        FinishActionEnabled := true;
    end;

    local procedure ResetControls();
    begin
        FinishActionEnabled := false;
        BackActionEnabled := true;
        NextActionEnabled := true;

        Step1Visible := false;
        Step2Visible := false;
        Step3Visible := false;
    end;

    local procedure LoadTopBanners();
    begin
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png', Format(CurrentClientType())) and
            MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png', Format(CurrentClientType()))
        then
            if MediaResourcesStandard.Get(MediaRepositoryStandard."Media Resources Ref") and
                MediaResourcesDone.Get(MediaRepositoryDone."Media Resources Ref")
        then
                TopBannerVisible := MediaResourcesDone."Media Reference".HasValue();
    end;

    local procedure LoadCustomBanner();
    var
        SetupKey: Code[20];
    begin
        SetupKey := 'BIODIVSETUP';
        if BioDiversitySetup.Get(SetupKey) then
            CustomBannerVisible := BioDiversitySetup.SetupWizardBanner.HasValue();

    end;

    local procedure LoadPlantsFromGitHub() Plants: JsonToken
    var
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        JsonObject: JsonObject;
        ResponseContent: Text;
    begin
        HttpClient.Get('https://raw.githubusercontent.com/microsoft/bcsamples-onboarding/main/App/plants.json', HttpResponseMessage);

        if HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpResponseMessage.Content().ReadAs(ResponseContent);
            JsonObject.ReadFrom(ResponseContent);
            JsonObject.Get('plants', Plants);
        end else
            Error('Error: Something went wrong while loading the plants from GitHub.');
    end;

    local procedure LoadJsonResponseToTempTable(Plants: JsonToken)
    var
        Plant, PlantName, PlantDescription : JsonToken;
    begin
        foreach Plant in Plants.AsArray() do begin
            Plant.AsObject().Get('name', PlantName);
            Plant.AsObject().Get('description', PlantDescription);

            Rec.Init();
            Rec.PlantCode := CopyStr(DelChr(Format(PlantName), '=', ' '), 1, 30);
            Rec.Name := CopyStr(PlantName.AsValue().AsText(), 1, 100);
            Rec.Description := CopyStr(PlantDescription.AsValue().AsText(), 1, 1000);
            Rec.Insert();
        end;
    end;

    local procedure FlushRecordsIntoDB()
    var
        Plant: Record MS_BioDiversityMgmtPlant;
    begin
        if Rec.FindSet() then
            repeat
                Plant.Init();
                Plant.PlantCode := Rec.PlantCode;
                Plant.Name := Rec.Name;
                Plant.Description := Rec.Description;
                Plant.Insert();
            until Rec.Next() = 0;
    end;
}