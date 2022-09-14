//
//  File.swift
//  
//
//  Created by MSP on 14.09.2022.
//

import ApphudSDK
import ComposableArchitecture
import StoreKit

public final class IAPManager: IAPManagerProtocol {

    public init() {}

    public var hasPremiumAccess: Bool {
        Apphud.hasPremiumAccess()
    }

    public func getProduct(
        by id: String
    ) -> Effect<SKProduct?, Never> {
        .task { [weak self] in
            guard let self = self else {
                return nil
            }

            let paywalls = await self.getPaywalls()
            let products = paywalls.flatMap(\.products)
            let product = products.first(where: { $0.productId == id })
            return product?.skProduct
        }
    }

    public func getProducts(
        by ids: Set<String>
    ) -> Effect<[String: SKProduct], Never> {
        .task { [weak self] in
            guard let self = self else {
                return [:]
            }

            let products = await self.getPaywalls()
                .flatMap(\.products)
                .filter { ids.contains($0.productId) }

            return .init(
                uniqueKeysWithValues: products.compactMap { product in
                    product.skProduct.map { skProduct in
                        (product.productId, skProduct)
                    }
                }
            )
        }
    }
}


// MARK: private
extension IAPManager {
    private func getPaywalls() async -> [ApphudPaywall] {
        await withCheckedContinuation { continuation in
            Apphud.paywallsDidLoadCallback { paywalls in
                continuation.resume(returning: paywalls)
            }
        }
    }
}
