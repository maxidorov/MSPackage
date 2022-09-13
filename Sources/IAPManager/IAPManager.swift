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

    public func getProduct(by id: String) -> Effect<SKProduct?, Never> {
        Effect.task { [weak self] in
            guard let self = self else { return nil }
            let paywalls = await self.getPaywalls()
            let products = paywalls.flatMap(\.products)
            let product = products.first(where: { $0.productId == id })
            return product?.skProduct
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
