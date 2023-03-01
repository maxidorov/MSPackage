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

    public func getProduct(
        by id: String
    ) -> Effect<IAPManagerGetResponse, IAPError> {
        .init(error: .unexpected)
    }

    public func getProducts(
        by ids: Set<String>
    ) -> Effect<IAPManagerGetResponse, IAPError> {
        .init(error: .unexpected)
    }

    public func purchaseProduct(
        with id: String
    ) -> Effect<Bool, IAPError> {
        .init(value: true)
    }

    public func restorePurchases() -> Effect<Bool, IAPError> {
        .init(value: true)
    }
}
