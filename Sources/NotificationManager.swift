//
//  File.swift
//  
//
//  Created by MSP on 09.09.2022.
//

import UserNotifications
import ComposableArchitecture

public enum NotificationManager {
  private static let notificationCenter = UNUserNotificationCenter.current()

  public static func requestAuthorization() -> Effect<Bool, Never> {
    Effect.task {
      let requestResult = try? await self.notificationCenter.requestAuthorization(
        options: .badge
      )
      return requestResult ?? false
    }
  }

  public static func setupEveryDayNotification(
    title: String,
    body: String,
    at dateComponents: DateComponents
  ) -> Effect<Bool, Never> {
    Effect.task {
      let requestResult = try? await self.notificationCenter.requestAuthorization(
        options: .badge
      )

      guard (requestResult ?? false) else {
        return false
      }

      return await withCheckedContinuation { continuation in
        let trigger = UNCalendarNotificationTrigger(
          dateMatching: dateComponents,
          repeats: true
        )

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body

        let request = UNNotificationRequest(
          identifier: UUID().uuidString,
          content: content,
          trigger: trigger
        )

        self.notificationCenter.add(request) { error in
          let success = error == nil
          continuation.resume(returning: success)
        }
      }
    }
  }

  public static func removeAllPendingNotifications() {
    notificationCenter.removeAllPendingNotificationRequests()
  }
}

