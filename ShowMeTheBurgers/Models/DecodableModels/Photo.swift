//
//  Photo.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 27.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct Photo {
  
  // MARK: - Properties
  
  let prefix: String
  let suffix: String
  
  // MARK: - Funcs
  
  func makeUrl(forSize size: PhotoSize) -> URL? {
    let urlString = prefix + size.rawValue + suffix
    return URL(string: urlString)
  }
}

// MARK: - PhotoSize

extension Photo {
  
  enum PhotoSize: String {
    case tiny   = "36x36"
    case small  = "100x100"
    case medium = "300x300"
    case large  = "500x500"
  }
}

// MARK: - Decodable

extension Photo: Decodable { }
