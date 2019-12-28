//
//  UILabelExtension.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 28.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import UIKit

extension UILabel {
  
  static func makeLoadingLabel() -> UILabel {
    let label = UILabel()
    label.text = "Gathering data..."
    label.textColor = .white
    label.font = .systemFont(ofSize: 15, weight: .semibold)
    label.alpha = 0
    return label
  }
  
  func show() {
    UIView.animate(withDuration: 0.3) {
      self.alpha = 1
    }
  }
  
  func hide() {
    UIView.animate(withDuration: 0.3) {
      self.alpha = 0
    }
  }
}
