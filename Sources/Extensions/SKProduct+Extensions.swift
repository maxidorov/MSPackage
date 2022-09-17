//
//  File.swift
//  
//
//  Created by MSP on 15.09.2022.
//

import StoreKit

extension SKProduct {
    public var localizedPrice: String? {
//        appendCurrency(to: price)
        localizedPrice(dividedBy: 1)
    }

    public var localizedSubscriptionPeriod: String? {
        // TODO: remove 1 in '1 year', '1 month'...

        guard let subscriptionPeriod = subscriptionPeriod else { return nil }

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

    public func appendCurrency(to price: NSDecimalNumber) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)?
            .replacingOccurrences(of: ".00", with: "")
            .replacingOccurrences(of: ",00", with: "")
    }

    public func localizedPrice(dividedBy: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale

        let price = NSDecimalNumber(
            value: Float(truncating: price) / Float(dividedBy)
        )

        return formatter.string(from: price)?
            .replacingOccurrences(of: ".00", with: "")
            .replacingOccurrences(of: ",00", with: "")
    }
}
