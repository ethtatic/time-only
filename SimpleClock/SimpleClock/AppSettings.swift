//
//  AppSettings.swift
//  SimpleClock
//

import Foundation
import Combine

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
    }

    enum Keys {
        static let showSeconds      = "simpleclock.showSeconds"
        static let showDate         = "simpleclock.showDate"
        static let blinkingColon    = "simpleclock.blinkingColon"
        static let showSettingsIcon = "simpleclock.showSettingsIcon"
        static let darkMode         = "simpleclock.darkMode"
    }
}
