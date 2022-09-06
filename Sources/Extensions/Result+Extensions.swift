//
//  File.swift
//  
//
//  Created by MSP on 07.09.2022.
//

import Foundation

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
