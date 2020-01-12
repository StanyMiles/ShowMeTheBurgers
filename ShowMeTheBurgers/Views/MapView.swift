//
//  MapView.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 12.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

//import UIKit
import MapKit

class MapView: MKMapView {
  
  static func makeMapView(delegate: MKMapViewDelegate) -> MapView {
    let mapView = MapView()
    mapView.layer.cornerRadius = 4
    mapView.delegate = delegate
    return mapView
  }
  
  func addRadiusCircle(coordinate: CLLocationCoordinate2D) {
    let circle = MKCircle(center: coordinate, radius: 1000)
    addOverlay(circle)
  }
  
  func centerMap(
    on coordinate: CLLocationCoordinate2D,
    regionRadius: CLLocationDistance = 4000
  ) {
    
    let coordinateRegion = MKCoordinateRegion(
      center: coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    
    setRegion(coordinateRegion, animated: true)
  }
}
