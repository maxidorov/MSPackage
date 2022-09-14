//
//  File.swift
//  
//
//  Created by MSP on 15.09.2022.
//

import StoreKit

extension SKProduct {
    public var localizedPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)
    }

    public var localizedSubscriptionPeriod: String? {
        guard let subscriptionPeriod = subscriptionPeriod else { return "" }

        let dateComponents: DateComponents

        switch subscriptionPeriod.unit {
        case .day:
            dateComponents = DateComponents(day: subscriptionPeriod.numberOfUnits)
        case .week:
            dateComponents = DateComponents(weekOfMonth: subscriptionPeriod.numberOfUnits)
        case .month:
            dateComponents = DateComponents(month: subscriptionPeriod.numberOfUnits)
        case .year:
            dateComponents = DateComponents(year: subscriptionPeriod.numberOfUnits)
        @unknown default:
            fatalError()
        }

        return DateComponentsFormatter.localizedString(
            from: dateComponents,
            unitsStyle: .full
        )
    }
}
