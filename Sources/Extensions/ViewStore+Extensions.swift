//
//  File.swift
//  
//
//  Created by MSP on 07.09.2022.
//

import SwiftUI
import ComposableArchitecture

public extension ViewStore {
  func sendAnimated(_ action: Action) {
    _ = withAnimation {
      send(action)
    }
  }
}
