//
//  BurgerJointViewModel.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 26.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import UIKit
import MapKit

class BurgerJointViewModel: NSObject {
  
  // MARK: - Properties
  
  let id: String
  let name: String
  let coordinate: CLLocationCoordinate2D
  let photo: Photo?
  
  // MARK: - Initializers
  
  init(venue: Venue, photo: Photo?) {
    id = venue.id
    name = venue.name
    coordinate = CLLocationCoordinate2D(
      latitude: venue.location.latitude,
      longitude: venue.location.longitude)
    self.photo = photo
  }
  
  // MARK: - Funcs
  
  func getPhotoUrl(forSize size: Photo.PhotoSize) -> URL? {
    photo?.makeUrl(forSize: size)
  }
  
}

// MARK: - MKAnnotation

extension BurgerJointViewModel: MKAnnotation {
  
  var title: String? {
    return name
  }
}
