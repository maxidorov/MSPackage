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
    private let paywallId = "main"

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
    ) -> Effect<IAPManagerGetResponse, IAPError> {
        .future { [weak self] promise in
            guard let self = self else {
                return promise(.failure(.selfIsNil))
            }

            Task {
                do {
                    guard let paywall = try await self.getPaywall(id: self.paywallId) else {
                        return promise(.failure(.paywallNotFound(paywallId: self.paywallId)))
                    }

                    let products = try await self.getProducts(paywall: paywall)

                    guard let skProduct =  products.first(where: { $0.vendorProductId == id })?.skProduct else {
                        return promise(.failure(.productNotFound(productId: id)))
                    }

                    promise(.success(.init(
                        paywall: paywall,
                        paywallId: self.paywallId,
                        paywallVariationId: paywall.variationId,
                        paywallConfigName: paywall.name, // MARK: What is paywallConfigName?
                        products: [.init(skProduct: skProduct, id: id)]
                    )))
                } catch {
                    promise(.failure(.error(error.localizedDescription)))
                }
            }
        }
    }

    public func getProducts(
        by ids: Set<String>
    ) -> Effect<IAPManagerGetResponse, IAPError> {
        .future { [weak self] promise in
            guard let self = self else {
                return promise(.failure(.selfIsNil))
            }

            Task {
                do {
                    guard let paywall = try await self.getPaywall(id: self.paywallId) else {
                        return promise(.failure(.paywallNotFound(paywallId: self.paywallId)))
                    }

                    let products = try await self.getProducts(paywall: paywall)
                        .map {
                            IAPManagerGetResponse.Product(
                                skProduct: $0.skProduct,
                                id: $0.skProduct.productIdentifier
                            )
                        }
                        .filter { ids.contains($0.id) }

                    guard !products.isEmpty else {
                        return promise(.failure(.productsNotFound(ids)))
                    }

                    promise(.success(.init(
                        paywall: paywall,
                        paywallId: self.paywallId,
                        paywallVariationId: paywall.variationId,
                        paywallConfigName: paywall.name,
                        products: products
                    )))
                } catch {
                    promise(.failure(.error(error.localizedDescription)))
                }
            }
        }
    }

    public func purchaseProduct(
        with id: String
    ) -> Effect<Bool, IAPError> {
        .future { [weak self] promise in
            guard let self else {
                return promise(.failure(.selfIsNil))
            }

            Task {
                do {
                    guard let paywall = try await self.getPaywall(id: self.paywallId) else {
                        return promise(.failure(.paywallNotFound(paywallId: self.paywallId)))
                    }

                    let products = try await self.getProducts(paywall: paywall)

                    guard let productToPurchase = products.first(where: {
                        $0.skProduct.productIdentifier == id
                    }) else { return promise(.failure(.productNotFound(productId: id))) }

                    let profile = try await Adapty.makePurchase(product: productToPurchase)
                    self.hasPremiumAccess = profile.hasPremiumAccessLevel
                    promise(.success(profile.hasPremiumAccessLevel))
                } catch {
                    promise(.failure(.error(error.localizedDescription)))
                }
            }
        }
    }

    public func restorePurchases() -> Effect<Bool, IAPError> {
        .future { promise in
            Adapty.restorePurchases { result in
                switch result {
                case let .success(profile):
                    self.hasPremiumAccess = profile.hasPremiumAccessLevel
                    promise(.success(profile.hasPremiumAccessLevel))
                case let .failure(error):
                    promise(.failure(.error(error.localizedDescription)))
                }
            }
        }
    }
}


// MARK: private
extension IAPManager {
    private func getPaywall(id: String) async throws -> AdaptyPaywall? {
        try await Adapty.getPaywall(id)
    }

    private func getProducts(paywall: AdaptyPaywall) async throws -> [AdaptyPaywallProduct] {
        let products = try await Adapty.getPaywallProducts(paywall: paywall)
        return products ?? []
    }
}

private extension AdaptyProfile {
    var hasPremiumAccessLevel: Bool {
        accessLevels["premium"]?.isActive ?? false
    }
}
