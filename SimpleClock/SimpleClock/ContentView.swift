//
//  ContentView.swift
//  SimpleClock
//
//  Created by Lorenz Pennewiss on 12.04.26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var settings: AppSettings
    @State private var showSettings = false

    var body: some View {
        TimelineView(.periodic(from: .now, by: 5)) { context in
            let now = context.date
            let hours = String(format: "%02d", Calendar.current.component(.hour, from: now))
            let minutes = String(format: "%02d", Calendar.current.component(.minute, from: now))

            ZStack {
                Color.dsBackground
                    .ignoresSafeArea()

                HStack(alignment: .center, spacing: Spacing.sm) {
                    Text(hours)
                        .font(.dsDisplay)
                        .foregroundStyle(Color.dsPrimary)
                        .tracking(-3.8)
                        .monospacedDigit()

                    SeparatorDots()

                    Text(minutes)
                        .font(.dsDisplay)
                        .foregroundStyle(Color.dsPrimary)
                        .tracking(-3.8)
                        .monospacedDigit()
                }

                if settings.showSettingsIcon {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "gearshape")
                                .font(.system(size: 20))
                                .foregroundStyle(Color.dsPrimary.opacity(0.2))
                                .padding(Spacing.xl)
                                .onTapGesture { showSettings = true }
                        }
                    }
                }
            }
            .gesture(
                LongPressGesture(minimumDuration: 0.5)
                    .onEnded { _ in showSettings = true }
            )
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(settings)
                    .presentationDetents([.medium])
            }
            .preferredColorScheme(settings.darkMode.map { $0 ? .dark : .light })
        }
    }
}

struct SeparatorDots: View {
    var body: some View {
        VStack(spacing: 18) {
            Circle()
                .frame(width: 8, height: 8)
            Circle()
                .frame(width: 8, height: 8)
        }
        .foregroundStyle(Color.dsAccent)
    }
}
