//
//  File.swift
//  
//
//  Created by MSP on 14.09.2022.
//

import ComposableArchitecture
import StoreKit

public enum IAPError: Error, Equatable {
    case skError(SKError)
    case custom(String)
}

public protocol IAPManagerProtocol {
    var hasPremiumAccess: Bool { get }

    func getProduct(
        by id: String
    ) -> Effect<SKProduct?, Never>

    func getProducts(
        by ids: Set<String>
    ) -> Effect<[String: SKProduct], Never>

    func purchaseProduct(
        with id: String
    ) -> Effect<Bool, IAPError>
}
