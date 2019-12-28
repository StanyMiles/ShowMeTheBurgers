//
//  APIMainResponse.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 26.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct APIMainReponse {
  let response: APIResponse
}

// MARK: - Decodable

extension APIMainReponse: Decodable { }
