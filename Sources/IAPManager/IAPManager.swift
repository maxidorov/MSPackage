//
//  File.swift
//  
//
//  Created by MSP on 14.09.2022.
//

import ApphudSDK
import StoreKit

final class IAPManager: IAPManagerProtocol {
    var hasPremiumAccess: Bool {
        Apphud.hasPremiumAccess()
    }
}
