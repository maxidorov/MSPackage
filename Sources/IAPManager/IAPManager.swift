//
//  File.swift
//  
//
//  Created by MSP on 14.09.2022.
//

import ApphudSDK
import StoreKit

public final class IAPManager: IAPManagerProtocol {
    
    public init() {}

    public var hasPremiumAccess: Bool {
        Apphud.hasPremiumAccess()
    }
}
