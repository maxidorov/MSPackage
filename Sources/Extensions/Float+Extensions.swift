//
//  File.swift
//  
//
//  Created by MSP on 17.09.2022.
//

import Foundation

public extension Float {
    func format(_ format: String) -> String {
        String(format: "%\(format)f", self)
    }

    func decimalPlaces(_ count: Int) -> String {
        format(".\(count)")
    }
}
