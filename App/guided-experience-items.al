codeunit 70074170 MS_CreateWelcomeExperience
{
    var
        //Define the texts for the Guided Experience Items the users will see in their checklists
        //If the user has profiled as coming from Excel, we want to show them a checklist item that makes them feel welcomed right off the bat
        SystemShortTitleTxt: Label 'Excel users love us';
        SystemTitleTxt: Label 'Excel users love using Business Central';
        SystemDescriptionTxt: Label 'With a seamless integration to Excel, you can easily work with data in Excel, and even import it back into Business Central. Great for manipulating lists of data.';

        //Depending on the user's company profile, add a Guided Experience Item that shows we know what they care about
        UsersShortTitleTxt: Label 'So, you have 10-25 users?';
        UsersTitleTxt: Label 'Your company is a great fit for Business Central';
        UsersDescriptionTxt: Label 'Business Central is great for companies with a user base of 10-25, but it does not stop there. Business Central empowers you to grow your business. See the video to learn how.';

        //When the user answered questions in the profiler (on your web site), ask them what they're looking for, and load a Guided Experience Item that confirms they've gone to the right place
        InterestShortTitleTxt: Label 'Trade is in our DNA';
        InterestTitleTxt: Label 'Trade is a cornerstone of Business Central';
        InterestDescriptionTxt: Label 'Business Central is one of the Worlds most powerful business solutions when it comes to Basic trade. Trade can be set up in any variance you want to help you run your business processes.';

        OnboardingSampleValueTxt: Label 'bcsamples-onboarding', Locked = true;


    //This event is used to set the sign-up context.
    //This happens at system initialization.
    //In a normal standard trial provisioning where this app is not installed, the sign-up context is set in standard Microsoft code.
    //In that scenario the sign-up context key/value pair is "name": "viral".
    //But in our scenario our app is installed when the BC trial is provisioned, so we have the opportunity to set our own sign-up context.
    //Why would we want to do that? Because the context allows us to pivot the experience. 
    //You could even have multiple contexts. Imagine you profile potential customers on your web site and depending on their answers you load different experiences.
    //This is managed by th sign-up context. 
    //With the event below we can set the sign-up context when the system initializes, so that we will know later on what we should react to.
    //Think of the signup context being a result of company profiling = determines _which_ app and _which_business scenario to load (industry, etc.)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"System Initialization", 'OnSetSignupContext', '', false, false)]
    local procedure SetSignupContext()
    var
        SignupContextValues: Record "Signup Context Values";
        SignupContext: Record "Signup Context";
        SpotlightTourType: Enum "Spotlight Tour Type";
        SpotlightTourTexts: Dictionary of [Enum "Spotlight Tour Text", Text];
        GuidedExperience: Codeunit "Guided Experience";
        GuidedExperienceType: Enum "Guided Experience Type";
        VideoCategory: Enum "Video Category";
        Checklist: Codeunit Checklist;
        TempAllProfile: Record "All Profile";
    begin
        //First, we check if BC was provisioned via a URL that contained a sign-up context name (= the name is stored in the Signup Context table)
        if not SignupContext.Get('name') then
            exit;

        if not (LowerCase(SignupContext.Value) = OnboardingSampleValueTxt) then
            exit;

        Clear(SignupContextValues);
        if not SignupContextValues.IsEmpty() then
            exit;

        //Now, we set our desired context. The context should identify your app. One app, one context.
        //Note, that you can react to other key value pairs if you want to do things depending on profiler answers.
        SignupContextValues."Signup Context" := SignupContextValues."Signup Context"::BCSampleOnboardingApp;
        SignupContextValues.Insert();

        //Add our Guided Experience Items we want to potentially add to the checklist
        //Add the guided experience items. Note, that here we just load three different videos for the "system", "users" and "interest" questions from the profiler
        //Add the checklist items you think makes sense to greet the user with, based on their profile.
        GetVendorListSpotlightTourDictionary(SpotlightTourTexts);
        GuidedExperience.InsertSpotlightTour(SystemTitleTxt, SystemShortTitleTxt, SystemDescriptionTxt, 2, Page::"Vendor List", SpotlightTourType::"Open in Excel", SpotlightTourTexts);
        GuidedExperience.InsertVideo(UsersTitleTxt, UsersShortTitleTxt, UsersDescriptionTxt, 1, 'https://www.youtube.com/embed/nqM79hlHuOs', VideoCategory::GettingStarted);
        GuidedExperience.InsertVideo(InterestTitleTxt, InterestShortTitleTxt, InterestDescriptionTxt, 1, 'https://www.youtube.com/embed/YpWD4ZrLobI', VideoCategory::GettingStarted);

        //Now, we read the SignupContext table where the profiler answers have been stored via the signupContext parameter in the URL when they started BC for the first time

        /* --- DO STUFF BASED ON THE CUSTOMER PROFILE ---  
        Here is where you check the SignupContext table for the profiler answers.
        Imagine you have a web site where you ask for:
        - Which system do you use today?
        - What is your interest / would you like to see / expect to find in BC?
        - How many users are in your company?

        Based on the answers to those questions we want to show different things in the checklist, in the welcome banner texts, tours etc.

        When you have the answers from your profiling (for example from a form on your web site) you must construct a URL with a correct signupContext.
        Read more about how to do that here: https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/administration/onboarding-signupcontext
        
        If you have done this right the answers from the customer profiling will be stored in a system table, "Signup Context".
        This means you can read them and determine what the customer answered and use those answers to pivot the experience.

        Let's give the user what they expect, no? :o)

        */

        //If the user said they use Excel today, create the checklist item from the Guided Experience Item we added above that shows why BC is great with Excel
        SignupContext.Reset();
        SignupContext.SetRange(SignupContext.KeyName, 'currentsystem'); //this key can be anything but has to match the output of your profiling, what you added to the URL based on the answers provided by the user
        SignupContext.SetRange(SignupContext.Value, 'Excel'); //This is an example of the profiler answer
        if SignupContext.FindSet() then begin
            Checklist.Insert(Page::"Vendor List", SpotlightTourType::"Open in Excel", 1000, TempAllProfile, false);
        end;

        //If they have told us they're looking for "Trade", let's show them something meaningful
        SignupContext.Reset();
        SignupContext.SetRange(SignupContext.KeyName, 'interest');
        SignupContext.SetRange(SignupContext.Value, 'Trade');
        if SignupContext.FindSet() then begin
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


    //This event lets you override the texts on the welcome banner. Use it to create that warm fuzzy feeling for users who see the role center for the first time
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
        TitleCollapsedTxt := 'Continue your experience';
        HeaderTxt := 'The last business solution you''ll ever need';
        HeaderCollapsedTxt := 'Continue exploring the trial';
        DescriptionTxt := 'You just started a trial for Business Central that is based on your company profile. We hope you''ll love it!';
    end;


    //Here we create the dictionary of texts used for the Spotlight tour where we call out the Excel integration (which we use on the Vendor List)
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

    //These procedures are needed to get the roles for the Business Manager Role Center, which we need in order to insert items into the checklist
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

}

//Your app needs to define a "sign-up context" name. You need to add this to the sign-up URL, along with the profiler answers.
//Make this something that identifies your app (but not the ID). It could include your publisher and app names. Try to make it as unique as possible.
//The sign-up context is useful if other apps want to align their experience to the context. 
enumextension 70074171 MS_BCSampleOnboardingApp extends "Signup Context"
{
    value(70074171; BCSampleOnboardingApp)
    {
        Caption = 'BCSamples-Onboarding';
    }
}
