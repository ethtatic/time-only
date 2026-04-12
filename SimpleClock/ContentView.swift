//
//  ContentView.swift
//  SimpleClock
//
//  Created by Lorenz Pennewiss on 12.04.26.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var now = Date.now
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text(now, style: .time)
                .font(.system(size: 72, weight: .thin, design: .monospaced))
                .foregroundStyle(.white)
                .monospacedDigit()
        }
        .onReceive(timer) { tick in now = tick }
    }
}