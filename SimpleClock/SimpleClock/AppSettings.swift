//
//  AppSettings.swift
//  SimpleClock
//

import Foundation
import Combine
import SwiftUI

final class AppSettings: ObservableObject {

    private let defaults: UserDefaults

    @Published var showSeconds: Bool {
        didSet { defaults.set(showSeconds, forKey: Keys.showSeconds) }
    }

    @Published var showDate: Bool {
        didSet { defaults.set(showDate, forKey: Keys.showDate) }
    }

    @Published var blinkingColon: Bool {
        didSet { defaults.set(blinkingColon, forKey: Keys.blinkingColon) }
    }

    @Published var showSettingsIcon: Bool {
        didSet { defaults.set(showSettingsIcon, forKey: Keys.showSettingsIcon) }
    }

    /// nil = use default dsAccent color
    @Published var colonColor: Color? {
        didSet {
            if let comps = colonColor?.rgbaComponents {
                defaults.set(comps, forKey: Keys.colonColor)
            } else {
                defaults.removeObject(forKey: Keys.colonColor)
            }
        }
    }

    /// nil = follow system; true = force dark; false = force light
    @Published var darkMode: Bool? {
        didSet {
            if let value = darkMode {
                defaults.set(value, forKey: Keys.darkMode)
            } else {
                defaults.removeObject(forKey: Keys.darkMode)
            }
        }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.showSeconds     = defaults.object(forKey: Keys.showSeconds)     as? Bool ?? true
        self.showDate        = defaults.object(forKey: Keys.showDate)        as? Bool ?? true
        self.blinkingColon   = defaults.object(forKey: Keys.blinkingColon)   as? Bool ?? false
        self.showSettingsIcon = defaults.object(forKey: Keys.showSettingsIcon) as? Bool ?? true
        self.darkMode        = defaults.object(forKey: Keys.darkMode)        as? Bool
        if let comps = defaults.object(forKey: Keys.colonColor) as? [Double], comps.count == 4 {
            self.colonColor = Color(red: comps[0], green: comps[1], blue: comps[2], opacity: comps[3])
        } else {
            self.colonColor = nil
        }
    }

    enum Keys {
        static let showSeconds      = "simpleclock.showSeconds"
        static let showDate         = "simpleclock.showDate"
        static let blinkingColon    = "simpleclock.blinkingColon"
        static let showSettingsIcon = "simpleclock.showSettingsIcon"
        static let darkMode         = "simpleclock.darkMode"
        static let colonColor       = "simpleclock.colonColor"
    }
}
