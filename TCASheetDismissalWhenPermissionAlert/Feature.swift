//
//  Feature.swift
//  TCASheetDismissalWhenPermissionAlert
//
//  Created by Tobias Kreß on 17.07.23.
//

import ComposableArchitecture
import SwiftUI

struct Feature: Reducer {
  struct State: Equatable {
    let identifier: String

    init(identifier: String) {
      self.identifier = identifier
    }
  }

  enum Action: Equatable {
    case didTapButton
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      return .none
    }
  }
}

struct FeatureView: View {
  let store: StoreOf<Feature>

  init(store: StoreOf<Feature>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        Text("Feature \(viewStore.identifier)")
        Button {
          store.send(.didTapButton)
        } label: {
          Text("Show Next Feature")
        }
      }
    }
  }
}
