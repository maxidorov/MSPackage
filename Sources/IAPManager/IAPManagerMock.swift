//
//  File.swift
//  
//
//  Created by MSP on 14.09.2022.
//

public final class IAPManagerMock: IAPManagerProtocol {
    public var hasPremiumAccess: Bool

    public init(
        hasPremiumAccess: Bool
    ) {
        self.hasPremiumAccess = hasPremiumAccess
    }
}
