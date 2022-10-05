//
//  File.swift
//  
//
//  Created by MSP on 06.10.2022.
//

import SwiftUI

public struct LinearProgressView: View {
  public struct Model {
    var current: Int
    var total: Int
    var backgroundColor: Color
    var foregroundColor: Color

    public init(
      current: Int,
      total: Int,
      backgroundColor: Color,
      foregroundColor: Color
    ) {
      self.current = current
      self.total = total
      self.backgroundColor = backgroundColor
      self.foregroundColor = foregroundColor
    }
  }

  private let model: Model

  private var progress: CGFloat {
    CGFloat(model.current) / CGFloat(model.total)
  }

  public init(model: Model) {
    self.model = model
  }

  public var body: some View {
    GeometryReader { geo in
      let size = geo.size

      ZStack(alignment: .leading) {
        model.backgroundColor

        model.foregroundColor
          .frame(width: size.width * progress, height: size.height)
      }
    }
  }
}
