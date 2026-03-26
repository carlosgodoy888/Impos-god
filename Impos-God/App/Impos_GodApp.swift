//
//  Impos_GodApp.swift
//  Impos-God
//
//  Created by Carlos Godoy Valverde on 26/3/26.
//

import SwiftUI

@main
struct Impos_GodApp: App {
    @StateObject private var appViewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
        }
    }
}
