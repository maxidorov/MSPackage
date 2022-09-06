//
//  File.swift
//  
//
//  Created by MSP on 07.09.2022.
//

import SwiftUI
import ComposableArchitecture

public struct CloseButton: View {
  private let action: Action

  public init(action: @escaping Action) {
    self.action = action
  }

  public var body: some View {
    Image(systemName: "xmark")
      .resizable()
      .frame(square: 22)
      .padding()
      .asButton(action: action)
  }
}
