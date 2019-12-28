//
//  PhotosAPIResponse.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 27.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct PhotosAPIResponse {
  let items: [Photo]
}

// MARK: - Decodable

extension PhotosAPIResponse: Decodable { }
