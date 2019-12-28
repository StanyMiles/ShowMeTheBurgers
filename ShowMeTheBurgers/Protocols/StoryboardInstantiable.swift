//
//  StoryboardInstantiatable.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 28.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable {
  static func instantiate() -> Self
}

extension StoryboardInstantiable where Self: UIViewController {
  
  static func instantiate() -> Self {
    
    let fullName = NSStringFromClass(self)
    let className = fullName.components(separatedBy: ".")[1]
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    
    return storyboard.instantiateViewController(withIdentifier: className) as! Self
  }
}
