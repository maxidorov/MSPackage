//
//  File.swift
//  
//
//  Created by MSP on 06.09.2022.
//

#if os(iOS)

import SwiftUI
import ComposableArchitecture

public typealias Action = () -> Void

public extension View {
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

    func asButton(action: @escaping Action) -> some View {
        Button(action: action, label: { self })
            .buttonStyle(.plain)
    }

    func frame(square value: CGFloat, alignment: Alignment = .center) -> some View {
        frame(width: value, height: value, alignment: alignment)
    }

    func frame(size: CGSize, alignment: Alignment = .center) -> some View {
        frame(width: size.width, height: size.height, alignment: alignment)
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

public extension Double {
    func format(_ format: String) -> String {
        String(format: "%\(format)f", self)
    }

    func decimalPlaces(_ count: Int) -> String {
        format(".\(count)")
    }

    func timeFormat(decimalPlaces: Int = 1) -> String {
        let minutes = Int(self / 60)
        let seconds = (self - Double(minutes * 60))
        let minutesStr = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secondsDecimal = seconds.decimalPlaces(decimalPlaces)
        let secondsStr = Double(secondsDecimal)! < 10 ? "0\(secondsDecimal)" : "\(secondsDecimal)"
        return "\(minutesStr):\(secondsStr)"
    }
}

public extension Int {
    var minAndSec: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60

        if minutes == 0 {
          return "\(seconds) sec"
        }

        if seconds == 0 {
          return "\(minutes) min"
        }

        return "\(minutes)m \(seconds)s"
    }
}

public extension ViewStore {
    func sendAnimated(_ action: Action) {
        _ = withAnimation {
            send(action)
        }
    }
}

public extension Date {
    var startOfToday: Date {
        Calendar.current.startOfDay(for: self)
    }

    var historyDateFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: self)
    }

    func appending(hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        Calendar.current.date(
            bySettingHour: hours,
            minute: minutes,
            second: seconds,
            of: self
        )
    }
}

public extension Result where Failure == Never {
    var value: Success {
        switch self {
        case let .success(value):
            return value
        case .failure:
            fatalError()
        }
    }
}

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

#endif
