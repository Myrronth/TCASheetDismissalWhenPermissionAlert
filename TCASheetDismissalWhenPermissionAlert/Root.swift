//
//  Root.swift
//  TCASheetDismissalWhenPermissionAlert
//
//  Created by Tobias Kreß on 17.07.23.
//

import ComposableArchitecture
import SwiftUI

struct Root: Reducer {
  public struct Destination: Reducer {
    public enum State: Equatable {
      case feature1(Feature.State)
      case feature2(Feature.State)
    }

    public enum Action: Equatable {
      case feature1(Feature.Action)
      case feature2(Feature.Action)
    }

    public var body: some ReducerOf<Self> {
      Scope(state: /State.feature1, action: /Action.feature1) {
        Feature()
      }
      Scope(state: /State.feature2, action: /Action.feature2) {
        Feature()
      }
    }
  }

  struct State: Equatable {
    @PresentationState public var destination: Destination.State?
  }

  public enum Action: Equatable {
    case didTapFeature1Button
    case destination(PresentationAction<Destination.Action>)
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        case .didTapFeature1Button:
          state.destination = .feature1(.init(identifier: "1"))
          return .none

        case .destination(.presented(.feature1(.didTapButton))):
          state.destination = .feature2(.init(identifier: "2"))
          return .none

        default:
          return .none
      }
    }
    .ifLet(\.$destination, action: /Action.destination) {
      Destination()
    }
  }
}

struct RootView: View {
  // This line causes the Feature2 sheet to dismiss and show up again immediately
  // when the scenePhase changes - but ONLY on iOS 15 (and maybe below, not able to test on a device)
  // Remove this and it also works as expected when running on iOS 15
  @Environment(\.scenePhase) var scenePhase

  let store: StoreOf<Root>

  init(store: StoreOf<Root>) {
    self.store = store
  }

  var body: some View {
    VStack {
      Text("Root")
      Button {
        store.send(.didTapFeature1Button)
      } label: {
        Text("Show Feature 1")
      }
    }
    .sheet(
      store: store.scope(state: \.$destination, action: Root.Action.destination),
      state: /Root.Destination.State.feature1,
      action: Root.Destination.Action.feature1,
      content: FeatureView.init
    )
    .sheet(
      store: store.scope(state: \.$destination, action: Root.Action.destination),
      state: /Root.Destination.State.feature2,
      action: Root.Destination.Action.feature2,
      content: FeatureView.init
    )
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    RootView(store: .init(initialState: .init(), reducer: Root()))
  }
}
