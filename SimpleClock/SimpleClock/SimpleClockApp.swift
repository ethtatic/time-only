//
//  SimpleClockApp.swift
//  SimpleClock
//
//  Created by Lorenz Pennewiss on 12.04.26.
//

import SwiftUI

@main
struct SimpleClockApp: App {
    @StateObject private var settings = AppSettings()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
                .statusBarHidden()
        }
        .onChange(of: scenePhase) { phase in
            UIApplication.shared.isIdleTimerDisabled = (phase == .active)
        }
    }
}
