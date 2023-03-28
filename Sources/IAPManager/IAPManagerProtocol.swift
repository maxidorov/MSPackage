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

    public struct RemoteConfig: Equatable, Decodable {
        public let canClose: Bool?
        public let paywallTitle: String?
        public let titleText: String?
        public let subtitleText: String?
        public let buttonText: String?

        private enum CodingKeys : String, CodingKey {
            case canClose = "can_close"
            case paywallTitle = "paywall_title"
            case titleText = "title_text"
            case subtitleText = "subtitle_text"
            case buttonText = "button_text"
        }
    }

    public var paywall: AdaptyPaywall
    public var paywallId: String
    public var paywallVariationId: String
    public var paywallConfigName: String
    public var products: [Product]
    public var remoteConfig: RemoteConfig?
}

extension AdaptyPaywall: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

public protocol IAPManagerProtocol {
    var hasPremiumAccess: Bool { get }

    func getProducts(
        paywallId: String
    ) -> Effect<IAPManagerGetResponse, IAPError>

    func purchaseProduct(
        id: String,
        paywallId: String
    ) -> Effect<Bool, IAPError>

    func restorePurchases() -> Effect<Bool, IAPError>
}
