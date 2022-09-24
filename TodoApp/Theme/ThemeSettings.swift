//
//  ThemeSettings.swift
//  TodoApp
//
//  Created by Usha Sai Chintha on 24/09/22.
//

import SwiftUI

final public class ThemeSettings: ObservableObject {
    @Published public var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
        didSet {
            UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
        }
    }
    
    private init() {}
    public static let shared = ThemeSettings()
}
