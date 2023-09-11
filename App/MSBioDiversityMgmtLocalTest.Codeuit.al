codeunit 70074171 MS_BioDiversityMgmtLocalTest
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        MSCreateWelcomeExperience: Codeunit MS_CreateWelcomeExperience;
    begin
        MSCreateWelcomeExperience.AddGuidedExperienceItems();
        MSCreateWelcomeExperience.FakeTestsWhenNotInSignup();
        MSCreateWelcomeExperience.SetCurrentUserRole();
    end;
}