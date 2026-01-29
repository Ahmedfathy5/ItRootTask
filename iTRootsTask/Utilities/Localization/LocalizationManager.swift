//
//  LocalizationManager.swift
//  iTRootsTask
//
//  Created by Ahmed Fathi on 29/01/2026.
//

import SwiftUI
import Combine

enum AppLanguage: String {
    case english = "en"
    case arabic = "ar"
}

final class LocalizationManager: Combine.ObservableObject {
    @SwiftUI.AppStorage("appLanguage") var appLanguage: String = AppLanguage.english.rawValue
}
