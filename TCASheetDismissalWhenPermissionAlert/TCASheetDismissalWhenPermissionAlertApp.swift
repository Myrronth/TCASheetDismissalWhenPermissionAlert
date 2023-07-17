//
//  TCASheetDismissalWhenPermissionAlertApp.swift
//  TCASheetDismissalWhenPermissionAlert
//
//  Created by Tobias Kreß on 17.07.23.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCASheetDismissalWhenPermissionAlertApp: App {
  let store: StoreOf<Root> = .init(initialState: .init(), reducer: Root())
  
  var body: some Scene {
    WindowGroup {
      RootView(store: store)
    }
  }
}
