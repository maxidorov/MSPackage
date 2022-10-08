//
//  File.swift
//  
//
//  Created by MSP on 07.09.2022.
//

#if os(iOS)

import SwiftUI
import ComposableArchitecture

public extension View {
  func frame(size: CGSize, alignment: Alignment = .center) -> some View {
    frame(width: size.width, height: size.height, alignment: alignment)
  }

  func frame(
    square value: CGFloat,
    alignment: Alignment = .center
  ) -> some View {
    frame(width: value, height: value, alignment: alignment)
  }

  func border(
    color: Color,
    cornerRadius: CGFloat,
    lineWidth: CGFloat
  ) -> some  View {
    overlay(
      RoundedRectangle(cornerRadius: cornerRadius)
        .stroke(color, lineWidth: lineWidth)
    )
  }

  func cornerRadius(
    _ radius: CGFloat,
    corners: UIRectCorner
  ) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }

  func asButton(action: @escaping Action) -> some View {
    Button(action: action, label: { self })
      .buttonStyle(.plain)
  }
}

public extension View {
  func sheet<State, Action, Content>(
    isPresented: Bool,
    store: Store<State, Action>,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping (Store<State, Action>) -> Content
  ) -> some View where Content: View {
    WithViewStore(store.scope(state: { _ in isPresented })) { isPresented in
      sheet(
        isPresented: Binding(get: { isPresented.state }, set: { _ in }),
        onDismiss: onDismiss,
        content: { content(store) }
      )
    }
  }

  func fullScreenCover<State, Action, Content>(
    isPresented: Bool,
    store: Store<State, Action>,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping (Store<State, Action>) -> Content
  ) -> some View where Content: View {
    WithViewStore(store.scope(state: { _ in isPresented })) { isPresented in
      fullScreenCover(
        isPresented: Binding(get: { isPresented.state }, set: { _ in }),
        onDismiss: onDismiss,
        content: { content(store) }
      )
    }
  }
}

struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners

  public func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}

public enum AlertStrings {
  case custom(title: String, message: String?)
  case error

  var strings: (title: String, message: String?) {
    switch self {
    case let .custom(title, message):
      return (title, message)
    case .error:
      return ("Ops, something went wrong :(", nil)
    }
  }
}

public extension View {
  func alert(
    _ alertStrings: AlertStrings,
    dismissButton: Alert.Button,
    isPresented: Binding<Bool>
  ) -> some View {
    alert(isPresented: isPresented) {
      Alert(
        title: Text(alertStrings.strings.title),
        message: alertStrings.strings.message.map { Text($0) },
        dismissButton: dismissButton
      )
    }
  }
}

#endif
