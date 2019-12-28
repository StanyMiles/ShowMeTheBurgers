//
//  MapHeaderView.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 26.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import UIKit
import MapKit

class MapHeaderView: UICollectionReusableView {
  
  // MARK: - Properties
  
  var mapView: MKMapView? {
    didSet {
      guard let mapView = mapView else { return }
      setup(mapView)
    }
  }
  
  var loadingLabel: UILabel? {
    didSet {
      guard let loadingLabel = loadingLabel else { return }
      setup(loadingLabel)
    }
  }
 
  // MARK: - Lifecycle
  
  override func prepareForReuse() {
    super.prepareForReuse()
    mapView?.removeFromSuperview()
    loadingLabel?.removeFromSuperview()
  }
  
  // MAKR: - Funcs
  
  private func setup(_ mapView: MKMapView) {
    addSubview(mapView)
    mapView.fillSuperview(padding: LayoutManager.mapPadding)
  }
  
  private func setup(_ loadingLabel: UILabel) {
    
    let padding = UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: 0,
      right: LayoutManager.mapHorizontalOffset)
    
    addSubview(loadingLabel)
    loadingLabel.anchor(
      top: topAnchor,
      leading: nil,
      bottom: nil,
      trailing: trailingAnchor,
      padding: padding)
  }
}
