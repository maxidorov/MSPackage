//
//  File.swift
//  
//
//  Created by MSP on 07.09.2022.
//

import Foundation

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
