//
//  File.swift
//  
//
//  Created by MSP on 14.09.2022.
//

import ComposableArchitecture
import StoreKit
import Adapty

public enum IAPError: Error, Equatable {
    case error(String)
    case skError(SKError)
    case paywallNotFound(paywallId: String)
    case productNotFound(productId: String)
    case productsNotFound(Set<String>)
    case selfIsNil
    case unexpected
}

public struct IAPManagerGetResponse: Equatable {
    public struct Product: Equatable {
        public var skProduct: SKProduct
        public var id: String
    }

    public var paywall: AdaptyPaywall
    public var paywallId: String
    public var paywallVariationId: String
    public var paywallConfigName: String
    public var products: [Product]
}

extension AdaptyPaywall: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

public protocol IAPManagerProtocol {
    var hasPremiumAccess: Bool { get }

    func getProduct(
        by id: String
    ) -> Effect<IAPManagerGetResponse, IAPError>

    func getProducts(
        by ids: Set<String>
    ) -> Effect<IAPManagerGetResponse, IAPError>

    func purchaseProduct(
        with id: String
    ) -> Effect<Bool, IAPError>

    func restorePurchases() -> Effect<Bool, IAPError>
}
