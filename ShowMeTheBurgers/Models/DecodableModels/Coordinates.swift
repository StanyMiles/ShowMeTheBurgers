//
//  Coordinates.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 26.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct Coordinates {
  let latitude: Double
  let longitude: Double
}

// MARK: - Decodable

extension Coordinates: Decodable {
  
  private enum CodingKeys: String, CodingKey {
    case latitude   = "lat"
    case longitude  = "lng"
  }
}
