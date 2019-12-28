//
//  GradientView.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 26.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
  
  // MARK: - Properties
  
  private lazy var startPoint: CGPoint = {
    let isPad = UIDevice.current.userInterfaceIdiom == .pad
    return isPad ? .init(x: 1, y: 0) : .init(x: 0, y: 0)
  }()
  
  private lazy var endPoint: CGPoint = {
    let isPad = UIDevice.current.userInterfaceIdiom == .pad
    return isPad ? .init(x: 0, y: 1) : .init(x: -0.25, y: 1)
  }()
  
  // MARK: - Views
  
  private lazy var gradientLayer: CAGradientLayer = {
    let gradient        = CAGradientLayer()
    gradient.startPoint = startPoint
    gradient.endPoint   = endPoint
    gradient.colors     = [#colorLiteral(red: 0.3490196078, green: 0.3529411765, blue: 0.9058823529, alpha: 1).cgColor, #colorLiteral(red: 0.8235294118, green: 0.2941176471, blue: 0.5411764706, alpha: 1).cgColor]
    return gradient
  }()
  
  // MARK: - Lifecycle
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    gradientLayer.frame = rect
    layer.addSublayer(gradientLayer)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = bounds
  }
}
