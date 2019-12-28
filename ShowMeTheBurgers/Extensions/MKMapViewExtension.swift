//
//  MKMapViewExtension.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 27.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import MapKit

extension MKMapView {
  
  static func makeMapView(delegate: MKMapViewDelegate) -> MKMapView {
    let mapView = MKMapView()
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
