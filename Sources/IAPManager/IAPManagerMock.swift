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

    public init(hasPremiumAccess: Bool) {
        self.hasPremiumAccess = hasPremiumAccess
    }

    public func getProducts(
        paywallId: String
    ) -> Effect<IAPManagerGetResponse, IAPError> {
        .init(error: .unexpected)
    }

    public func purchaseProduct(
        id: String,
        paywallId: String
    ) -> Effect<Bool, IAPError> {
        .init(value: true)
    }

    public func restorePurchases() -> Effect<Bool, IAPError> {
        .init(value: true)
    }
}
