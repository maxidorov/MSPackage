//
//  File.swift
//  
//
//  Created by MSP on 14.09.2022.
//

import Adapty
import ComposableArchitecture
import StoreKit

public final class IAPManager: IAPManagerProtocol {

    @Storage
    public var hasPremiumAccess: Bool

    public init(hasPremiumAccessKey: String) {
        self._hasPremiumAccess = .init(
            key: hasPremiumAccessKey,
            defaultValue: false
        )
    }

    public func getProduct(
        by id: String
    ) -> Effect<SKProduct?, Never> {
        .task { [weak self] in
            guard let self = self else {
                return nil
            }

            do {
                let products = try await self.getProducts()
                return products.first(where: { $0.vendorProductId == id })?.skProduct
            } catch {
                return nil
            }
        }
    }

    public func getProducts(
        by ids: Set<String>
    ) -> Effect<[String: SKProduct], Never> {
        .task { [weak self] in
            guard let self = self else {
                return [:]
            }

            do {
                let products = try await self.getProducts()
                    .map(\.skProduct)
                    .filter { ids.contains($0.productIdentifier) }

                return .init(
                    uniqueKeysWithValues: products.compactMap { product in
                        (product.productIdentifier, product)
                    }
                )
            } catch {
                return [:]
            }
        }
    }

    public func purchaseProduct(
        with id: String
    ) -> Effect<Bool, IAPError> {
        .future { [weak self] promise in
            guard let self else {
                return promise(.failure(.custom("self is nil")))
            }

            Task {
                do {
                    let products = try await self.getProducts()

                    guard let productToPurchase = products.first(where: {
                        $0.skProduct.productIdentifier == id
                    }) else { return promise(.failure(.custom("Product with id \(id) not found"))) }

                    let profile = try await Adapty.makePurchase(product: productToPurchase)

                    self.hasPremiumAccess = profile.hasPremiumAccessLevel
                    return promise(.success(profile.hasPremiumAccessLevel))
                } catch {
                    return promise(.failure(.custom("Unexpected error")))
                }
            }
        }
    }

    public func restorePurchases() -> Effect<Bool, Never> {
        .task {
            await withCheckedContinuation { continuation in
                Adapty.restorePurchases { result in
                    switch result {
                    case let .success(profile):
                        self.hasPremiumAccess = profile.hasPremiumAccessLevel
                        continuation.resume(returning: profile.hasPremiumAccessLevel)
                    case .failure:
                        continuation.resume(returning: false)
                    }
                }
            }
        }
    }
}


// MARK: private
extension IAPManager {
    private func getProducts() async throws -> [AdaptyPaywallProduct] {
        guard let mainPaywall = try await Adapty.getPaywall("main") else {
            return []
        }
        let products = try await Adapty.getPaywallProducts(paywall: mainPaywall)
        return products ?? []
    }
}

private extension AdaptyProfile {
    var hasPremiumAccessLevel: Bool {
        accessLevels["premium"]?.isActive ?? false
    }
}
