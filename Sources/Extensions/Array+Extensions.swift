//
//  File.swift
//  
//
//  Created by MSP on 08.09.2022.
//

import Foundation

public extension Array {
  func element(at index: Int) -> Element? {
    (0..<count).contains(index) ? self[index] : nil
  }
}
