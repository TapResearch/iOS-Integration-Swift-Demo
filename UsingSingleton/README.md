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
$ open TapResearchSwiftDemoSingleton.xcworkspace
~~~~~

* If you want to see the app in action make sure you add your iOS api token in `AppDelegate.swift` and a user identifier in `PlacementSelectorVC.swift`.

~~~~swift
    
    TapResearch.initWithApiToken(tapResearchApiToken, rewardDelegate: self, placementDelegate: self)
    TapResearch.setUniqueUserIdentifier(uniqueUserIdentifier)

~~~~

Please send all questions, concerns, or bug reports to developers@tapresearch.com.
