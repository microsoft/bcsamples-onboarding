codeunit 70074170 MS_CreateWelcomeExperience
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"System Initialization", 'OnSetSignupContext', '', false, false)]
    local procedure SetSignupContext(SignupContext: Record "Signup Context")
    var
        SignupContextValues: Record "Signup Context Values";
    begin
        if not SignupContext.Get('name') then
            exit;

        if not (LowerCase(SignupContext.Value) = 'name') then
            exit;

        Clear(SignupContextValues);
        if not SignupContextValues.IsEmpty() then
            exit;

        SignupContextValues."Signup Context" := SignupContextValues."Signup Context"::BCSampleOnboardingApp;
        SignupContextValues.Insert();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"System Initialization", 'OnAfterLogin', '', false, false)]
    local procedure InitializeChecklistOnAfterLogIn()
    var
        //Define the texts for the Guided Experience Items the users will see in their checklists

        //If the user has profiled as coming from Excel, we want to show them a checklist item that makes them feel welcomed right off the bat
        SystemShortTitleTxt: Label 'Excel users love us';
        SystemTitleTxt: Label 'Excel users love using Business Central';
        SystemDescriptionTxt: Label 'With a seamless integration to Excel, you can work with data in Excel, and import it back into Business Central.';

        //Depending on the user's company profile, add a Guided Experience Item that shows we know what they care about
        UsersShortTitleTxt: Label 'So, you have 10-25 users?';
        UsersTitleTxt: Label 'Your company is a great fit for Business Central';
        UsersDescriptionTxt: Label 'Business Central is great for companies with a user base of 10-25, but it does not stop there. Business Central empowers you to grow your business. See the video to learn how.';

        //When the user answered questions in the profiler (on your web site), ask them what they're looking for, and load a Guided Experience Item that confirms they've gone to the right place
        InterestShortTitleTxt: Label 'Trade is in our DNA';
        InterestTitleTxt: Label 'Trade is a cornerstone of Business Central';
        InterestDescriptionTxt: Label 'Business Central is one of the Worlds most powerful business solutions when it comes to Basic trade. Trade can be set up in any variance you want to help you run your business processes.';

        GuidedExperience: Codeunit "Guided Experience";
        GuidedExperienceType: Enum "Guided Experience Type";
        VideoCategory: Enum "Video Category";
        Checklist: Codeunit Checklist;
        TempAllProfile: Record "All Profile";
        SignupContext: Record "Signup Context";
        SignupContextValues: Record "Signup Context Values";
        SpotlightTourType: Enum "Spotlight Tour Type";
        SpotlightTourTexts: Dictionary of [Enum "Spotlight Tour Text", Text];
    begin
        if not SignupContextValues.Get() then
            exit;

        if not (SignupContextValues."Signup Context" = SignupContextValues."Signup Context"::BCSampleOnboardingApp) then
            exit;

        //Add our Guided Experience Items we want to potentially add to the checklist
        //Add the guided experience items. Note, that here we just load three different videos for the "system", "users" and "interest" questions from the profiler
        //Add the checklist items you think makes sense to greet the user with, based on their profile.
        GetVendorListSpotlightTourDictionary(SpotlightTourTexts);
        GuidedExperience.InsertSpotlightTour(SystemTitleTxt, SystemShortTitleTxt, SystemDescriptionTxt, 2, Page::"Vendor List", SpotlightTourType::"Open in Excel", SpotlightTourTexts);
        GuidedExperience.InsertVideo(UsersTitleTxt, UsersShortTitleTxt, UsersDescriptionTxt, 1, 'https://www.youtube.com/embed/nqM79hlHuOs', VideoCategory::GettingStarted);
        GuidedExperience.InsertVideo(InterestTitleTxt, InterestShortTitleTxt, InterestDescriptionTxt, 1, 'https://www.youtube.com/embed/YpWD4ZrLobI', VideoCategory::GettingStarted);

        //Now, we read the SignupContext table where the profiler answers have been stored via the signupContext parameter in the URL when they started BC for the first time

        //If we determine that the user signified that they came from Excel, create the checklist item from the Guided Experience Item we added above
        SignupContext.Reset();
        SignupContext.SetRange(SignupContext.KeyName, 'currentsystem');
        SignupContext.SetRange(SignupContext.Value, 'Excel');
        if SignupContext.FindSet() then begin
            Message('Signup context found:' + SignupContext.Value);
            Checklist.Insert(GuidedExperienceType::"Spotlight Tour", ObjectType::Page, Page::"Vendor List", 1000, TempAllProfile, false);
        end;

        //If they have told us they're looking for "Trade", let's show them something meaningful
        SignupContext.Reset();
        SignupContext.SetRange(SignupContext.KeyName, 'interest');
        SignupContext.SetRange(SignupContext.Value, 'Trade');
        if SignupContext.FindSet() then begin
            Message('Signup context found:' + SignupContext.Value);
            Checklist.Insert(GuidedExperienceType::Video, 'https://www.youtube.com/embed/YpWD4ZrLobI', 3000, TempAllProfile, false);
        end;

        //Let's speak their language with a great video, if they say they're 10-25 users in the company
        SignupContext.Reset();
        SignupContext.SetRange(SignupContext.KeyName, 'users');
        SignupContext.SetRange(SignupContext.Value, '10-25');
        if SignupContext.FindSet() then begin
            Checklist.Insert(GuidedExperienceType::Video, 'https://www.youtube.com/embed/nqM79hlHuOs', 1000, TempAllProfile, false);
        end;
    end;

    local procedure GetRolesForNonEvaluationCompany(var TempAllProfile: Record "All Profile" temporary)
    begin
        AddRoleToList(TempAllProfile, Page::"Business Manager Role Center");
    end;

    local procedure AddRoleToList(var TempAllProfile: Record "All Profile" temporary; RoleCenterID: Integer)
    var
        AllProfile: Record "All Profile";
    begin
        AllProfile.SetRange("Role Center ID", RoleCenterID);
        AddRoleToList(AllProfile, TempAllProfile);
    end;

    local procedure AddRoleToList(var AllProfile: Record "All Profile"; var TempAllProfile: Record "All Profile" temporary)
    begin
        if AllProfile.FindFirst() then begin
            TempAllProfile.TransferFields(AllProfile);
            TempAllProfile.Insert();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Checklist Banner", 'OnBeforeUpdateBannerLabels', '', false, false)]
    local procedure OnBeforeUpdateBannerLabels(var IsHandled: Boolean; IsEvaluationCompany: Boolean; var TitleTxt: Text; var TitleCollapsedTxt: Text; var HeaderTxt: Text; var HeaderCollapsedTxt: Text; var DescriptionTxt: Text)
    var
        User: Record User;
    begin
        IsHandled := true;

        User.Reset();
        User.SetRange(User."User Security ID", Database.UserSecurityId());
        User.FindFirst();

        TitleTxt := 'Welcome ' + User."Full Name" + '!';
        TitleCollapsedTxt := 'Title Collap Text';
        HeaderTxt := 'The last business solution you''ll ever need';
        HeaderCollapsedTxt := 'Continue exploring the trial';
        DescriptionTxt := 'You just started a trial for Business Central that is based on your company profile. We hope you''ll love it!';
    end;

    local procedure GetVendorListSpotlightTourDictionary(var SpotlightTourTexts: Dictionary of [Enum "Spotlight Tour Text", Text])
    var
        AnalyseGLEntriesInExcelStep1Title: Label 'Easily analyse list data in Excel';
        AnalyseGLEntriesInExcelStep1Descr: Label 'You can export any list to Excel - even Excel online. You can also edit data in Excel';
        AnalyseGLEntriesInExcelStep2Title: Label 'Here you''ll find actions to open lists and cards in other applications';
        AnalyseGLEntriesInExcelStep2Descr: Label 'Try opening this Vendor list in Excel and import it back into Business Central';
        SpotlightTourText: Enum "Spotlight Tour Text";
    begin
        SpotlightTourTexts.Add(SpotlightTourText::Step1Title, AnalyseGLEntriesInExcelStep1Title);
        SpotlightTourTexts.Add(SpotlightTourText::Step1Text, AnalyseGLEntriesInExcelStep1Descr);
        SpotlightTourTexts.Add(SpotlightTourText::Step2Title, AnalyseGLEntriesInExcelStep2Title);
        SpotlightTourTexts.Add(SpotlightTourText::Step2Text, AnalyseGLEntriesInExcelStep2Descr);
    end;

}

enumextension 70074171 MS_BCSampleOnboardingApp extends "Signup Context"
{
    value(70074171; BCSampleOnboardingApp)
    {
        Caption = 'BCSamples-Onboarding-SignupContext ';
    }
}