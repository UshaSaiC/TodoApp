//
//  ThemeSettings.swift
//  TodoApp
//
//  Created by Usha Sai Chintha on 24/09/22.
//

import SwiftUI

class ThemeSettings: ObservableObject {
  @Published var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
    didSet {
      UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
    }
  }
}
