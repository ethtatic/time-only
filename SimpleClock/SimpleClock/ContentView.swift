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

    private static let dateFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "EEEE, d MMMM"
        return fmt
    }()

    private var tickInterval: Double {
        settings.showSeconds || settings.blinkingColon ? 1.0 : 60.0
    }

    var body: some View {
        TimelineView(.periodic(from: .now, by: tickInterval)) { context in
            let now = context.date
            let cal = Calendar.current
            let hours  = String(format: "%02d", cal.component(.hour,   from: now))
            let minutes = String(format: "%02d", cal.component(.minute, from: now))
            let second  = cal.component(.second, from: now)
            let seconds = String(format: "%02d", second)

            ZStack {
                Color.dsBackground
                    .ignoresSafeArea()

                VStack(spacing: Spacing.md) {
                    HStack(alignment: .center, spacing: Spacing.sm) {
                        Text(hours)
                            .font(.dsDisplay)
                            .foregroundStyle(Color.dsPrimary)
                            .tracking(-3.8)
                            .monospacedDigit()

                        SeparatorDots(blinking: settings.blinkingColon, second: second, color: settings.colonColor ?? .dsAccent)
                            .padding(.leading, 6)

                        Text(minutes)
                            .font(.dsDisplay)
                            .foregroundStyle(Color.dsPrimary)
                            .tracking(-3.8)
                            .monospacedDigit()

                        if settings.showSeconds {
                            Text(":\(seconds)")
                                .font(.dsTitle)
                                .foregroundStyle(Color.dsSecondary)
                                .monospacedDigit()
                        }
                    }

                    if settings.showDate {
                        Text(Self.dateFormatter.string(from: now))
                            .font(.dsCaption)
                            .foregroundStyle(Color.dsSecondary)
                    }
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

struct SeparatorDots: View {
    var blinking: Bool = false
    var second: Int = 0
    var color: Color = .dsAccent

    var body: some View {
        VStack(spacing: 18) {
            Circle().frame(width: 8, height: 8)
            Circle().frame(width: 8, height: 8)
        }
        .foregroundStyle(color)
        .opacity(blinking && second % 2 != 0 ? 0 : 1)
        .animation(.easeInOut(duration: 0.25), value: second)
    }
}
