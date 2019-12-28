//
//  Venue.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 26.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct Venue {
  let id: String
  let name: String
  let location: Coordinates
}

// MARK: - Decodable

extension Venue: Decodable { }

// MARK: - Equatable

extension Venue: Equatable {
  
  static func == (lhs: Venue, rhs: Venue) -> Bool {
    lhs.id == rhs.id
  }
}
