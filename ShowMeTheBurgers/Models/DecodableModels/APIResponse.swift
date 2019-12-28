//
//  APIResponse.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 26.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct APIResponse {
  let venues: [Venue]?
  let photos: PhotosAPIResponse?
}

// MARK: - Decodable

extension APIResponse: Decodable { }
