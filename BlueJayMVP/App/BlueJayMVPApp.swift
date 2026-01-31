//
//  BlueJayMVPApp.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 9/1/25.
//

import SwiftUI
import RevenueCat

@main
struct BlueJayMVPApp: App {
    @State private var appModel: AppModel
    
    init() {
        // Configure RevenueCat at app launch
        let revenueCat = RevenueCatService.shared
        revenueCat.configure()
        _appModel = State(initialValue: AppModel(revenueCat: revenueCat))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
                .environment(RevenueCatService.shared)
        }
    }
}
