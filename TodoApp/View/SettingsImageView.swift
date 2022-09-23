//
//  SettingsImageView.swift
//  TodoApp
//
//  Created by Usha Sai Chintha on 24/09/22.
//

import SwiftUI

struct SettingsImageView: View {
    
    var index: Int
    
    @EnvironmentObject var iconSettings: IconNames
    
    var body: some View {
                Image(uiImage: UIImage(named: self.iconSettings.iconNames[index] ?? "Blue") ?? UIImage())
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .cornerRadius(8)
    }
}

struct SettingsImageView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsImageView(index: 0)
            .environmentObject(IconNames())
    }
}
