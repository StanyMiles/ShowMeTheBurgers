//
//  MockData.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 27.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct MockData {
  
  static func getImageUrl(for id: String) -> Photo? {
    let data = [
      "51f0e9ba498e9e870d3c2609": "https://fastly.4sqi.net/img/general/300x300/29127797_Dy_MJu32ClyADbetYUlSv1KYhT5O_QWGbTdMCIYSAlQ.jpg",
      "50efee8ce4b0a667694989f7": "https://fastly.4sqi.net/img/general/300x300/10972406_9E6erxXAJamopX_KOBSFr_74DFxDxnpxgCE6t4pkiaw.jpg",
      "4fddc66ee4b044e822e72fe6": "https://fastly.4sqi.net/img/general/300x300/4495867__HsoPFjbsWlCOjVut_11I_LwSNCnvwqm8R_D7bXiYus.jpg",
      "4d22e8fbf7a9a143b56c439f": "https://fastly.4sqi.net/img/general/300x300/YQWWPPO5BPG3JJVP3WZUGNKPG402LZF2DQSNPIOZAJXAEHFR.jpg",
      "5aff05e888a48b00249194cf": "https://fastly.4sqi.net/img/general/300x300/14084990_ntySOe1rwVexp875gP_2FIMMFUyGfIsookMKGhheQh4.jpg"
    ]
    
    guard let url = data[id]?.replacingOccurrences(of: "300x300", with: "#") else {
      return nil
    }
    let a = url.split(separator: "#").map { String($0) }
    
    return Photo(prefix: a[0], suffix: a[1])
  }
}
