//
//  File.swift
//  
//
//  Created by MSP on 07.09.2022.
//

import Foundation

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
