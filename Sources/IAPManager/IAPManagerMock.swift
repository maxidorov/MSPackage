//
//  File.swift
//  
//
//  Created by MSP on 14.09.2022.
//

import ComposableArchitecture
import StoreKit

public final class IAPManagerMock: IAPManagerProtocol {
    public var hasPremiumAccess: Bool

    public init(
        hasPremiumAccess: Bool
    ) {
        self.hasPremiumAccess = hasPremiumAccess
    }

    public func getProduct(by id: String) -> Effect<SKProduct?, Never> {
        .init(value: nil)
    }
}
