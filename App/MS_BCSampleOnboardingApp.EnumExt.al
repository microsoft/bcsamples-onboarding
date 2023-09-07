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