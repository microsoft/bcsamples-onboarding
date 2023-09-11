codeunit 70074171 MSBCSampleOnboardingLocalTest
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        MSCreateWelcomeExperience: Codeunit MSCreateWelcomeExperience;
    begin
        MSCreateWelcomeExperience.AddGuidedExperienceItems();
        MSCreateWelcomeExperience.FakeTestsWhenNotInSignup();
        MSCreateWelcomeExperience.SetCurrentUserRole();
    end;
}