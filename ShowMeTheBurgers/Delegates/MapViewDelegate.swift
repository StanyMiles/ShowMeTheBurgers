//
//  MapViewDelegate.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 27.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import MapKit

class MapViewDelegate: NSObject {
  
  // MARK: - Properties
  
  private weak var viewController: UIViewController?
  private let didSelectVenue: (BurgerJointViewModel) -> Void
  
  // MARK: - Initializer
  
  init(
    viewController: UIViewController,
    didSelectVenue: @escaping (BurgerJointViewModel) -> Void
  ) {
    self.viewController = viewController
    self.didSelectVenue = didSelectVenue
  }
}

// MARK: - MKMapViewDelegate

extension MapViewDelegate: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      let circle = MKCircleRenderer(overlay: overlay)
      circle.strokeColor = .red
      circle.fillColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.1)
      circle.lineWidth = 1
      return circle
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      guard let viewModel = annotation as? BurgerJointViewModel else {
        return nil
      }
      
      let identifier = "burgerJoint"
      let annotationView: MKAnnotationView
      if let existingView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
        annotationView = existingView
      } else {
        annotationView = MKPinAnnotationView(
          annotation: viewModel,
          reuseIdentifier: identifier)
      }
      annotationView.canShowCallout = true
      return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
      guard let viewModel = view.annotation as? BurgerJointViewModel else { return }
      didSelectVenue(viewModel)
    }
}
