//
//  File.swift
//  
//
//  Created by MSP on 05.10.2022.
//

import SwiftUI

public struct PaywallFooterView: View {
  public struct Model {
    let privacyPolicyTapped: Action
    let termsOfUseTapped: Action
    let restorePurchasesTapped: Action

    public init(
      privacyPolicyTapped: @escaping Action,
      termsOfUseTapped: @escaping Action,
      restorePurchasesTapped: @escaping Action
    ) {
      self.privacyPolicyTapped = privacyPolicyTapped
      self.termsOfUseTapped = termsOfUseTapped
      self.restorePurchasesTapped = restorePurchasesTapped
    }
  }

  let model: Model

  public init(model: Model) {
    self.model = model
  }

  public var body: some View {
    GeometryReader { geo in
      let textWidth = geo.size.width / 3

      HStack {
        Text("privacy policy")
          .frame(width: textWidth)
          .footerViewStyled()
          .asButton(action: model.privacyPolicyTapped)

        Text("restore purchases")
          .frame(width: textWidth)
          .footerViewStyled()
          .asButton(action: model.restorePurchasesTapped)

        Text("terms of use")
          .frame(width: textWidth)
          .footerViewStyled()
          .asButton(action: model.termsOfUseTapped)
      }
    }
    .frame(height: 20)
  }
}

private extension View {
  func footerViewStyled() -> some View {
    self
      .font(.system(size: 14, weight: .regular, design: .rounded))
      .minimumScaleFactor(0.1)
      .foregroundColor(.black.opacity(0.7))
  }
}
