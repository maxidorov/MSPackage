//
//  File.swift
//  
//
//  Created by MSP on 07.09.2022.
//

import Foundation

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
    let secondsStr = Double(secondsDecimal)! < 10
      ? "0\(secondsDecimal)"
      : "\(secondsDecimal)"
    return "\(minutesStr):\(secondsStr)"
  }
}
