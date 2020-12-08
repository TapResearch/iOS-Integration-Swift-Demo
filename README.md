# TapResearch iOS Integration for Swift demo app

This simple app demonstrates how to integrate the TapResearch SDK in your app.

* Clone the repo

~~~~~~bash
$ git clone git@github.com:TapResearch/iOS-Integration-Swift-Demo.git
~~~~~~

* Make sure you have [CocoaPods](https://cocoapods.org/) and install the TapResearch pod

~~~~~bash
$ pod install
~~~~~

* Open the workspace

~~~~~bash
$ open TapResearchSwiftDemo.xcworkspace
~~~~~

* If you want to see the app in action make sure you add your iOS api token and a user identifier in `AppDelegate.swift`

~~~~swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    TapResearch.initWithApiToken(tapResearchApiToken, delegate: self)
    TapResearch.setUniqueUserIdentifier(userIdentifier)

    return true
}

~~~~

Please send all questions, concerns, or bug reports to developers@tapresearch.com.
