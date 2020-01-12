//
//  MainViewController.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 26.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UICollectionViewController {
  
  // MARK: - Views
  
  private lazy var mapView: MapView = {
    MapView.makeMapView(delegate: mapViewDelegate)
  }()
  
  private lazy var loadingLabel: UILabel = {
    UILabel.makeLoadingLabel()
  }()
  
  // MARK: - Delegates
  
  private lazy var mapViewDelegate: MKMapViewDelegate = {
    MapViewDelegate(
      viewController: self,
      didSelectVenue: { [weak self] venue in
        guard let self = self else { return }
        self.presentDetails(for: venue)
    })
  }()
  
  private lazy var collectionViewDelegate: CollectionViewDelegate = {
    CollectionViewDelegate(
      viewController: self,
      didSelectIndexPath: { [weak self] indexPath in
        guard let self = self else { return }
        self.didSelectItem(at: indexPath)
    })
  }()
  
  // MARK: - Properties
  
  private var networking = NetworkingFacade()
  private var burgerJointsWithPhoto: [BurgerJointViewModel] = []
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupData()
  }
  
  override func viewWillTransition(
    to size: CGSize,
    with coordinator: UIViewControllerTransitionCoordinator
  ) {
    super.viewWillTransition(to: size, with: coordinator)
    collectionView.collectionViewLayout.invalidateLayout()
  }
  
  // MARK: - Funcs
  
  private func setupViews() {
    navigationController?.navigationBar.prefersLargeTitles = true
    
    collectionView.delegate = collectionViewDelegate
    collectionView.register(
      MapHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: CellIdentifier.mapHeaderId)
    
    setupMapView()
  }
  
  private func setupMapView() {
    let latitude = CLLocationDegrees(exactly: APIKeys.latitude)!
    let longitude = CLLocationDegrees(exactly: APIKeys.longitude)!
    
    let coordinate = CLLocationCoordinate2D(
      latitude: latitude,
      longitude: longitude)
    
    mapView.centerMap(on: coordinate)
    mapView.addRadiusCircle(coordinate: coordinate)
  }
  
  private func setupData() {
    loadingLabel.show()
    
    let coordinates = Coordinates(
      latitude: APIKeys.latitude,
      longitude: APIKeys.longitude)
    
    networking.requestFilteredBurgerJoints(
      excludedAreaCenter: coordinates
    ) { [weak self] result in
      
      guard let self = self else { return }
      
      switch result {
      case .success(let burgerJoints):
        
        self.burgerJointsWithPhoto = burgerJoints.filter { $0.photo != nil }
        
        var indexPaths: [IndexPath] = []
        
        for i in 0..<self.burgerJointsWithPhoto.count {
          let newIndexPath = IndexPath(item: i, section: 0)
          indexPaths.append(newIndexPath)
        }
        
        DispatchQueue.main.async {
          self.mapView.addAnnotations(burgerJoints)
          self.collectionView.insertItems(at: indexPaths)
          self.loadingLabel.hide()
        }
        
      case .failure(let error):
        DispatchQueue.main.async {
          self.loadingLabel.hide()
          self.presentAlert()
        }
        
        #if DEBUG
        print("Failed to download data:", error)
        #endif
      }
    }
  }
  
  private func didSelectItem(at indexPath: IndexPath) {
    let burgerJoint = burgerJointsWithPhoto[indexPath.item]
    let viewController = DetailViewController.instantiate(
      with: burgerJoint.photo,
      title: burgerJoint.name)
    navigationController?.pushViewController(viewController, animated: true)
  }
  
  private func presentDetails(for burgerJoint: BurgerJointViewModel) {
    let viewController = DetailViewController.instantiate(
      with: burgerJoint.photo,
      title: burgerJoint.name)
    navigationController?.pushViewController(viewController, animated: true)
  }
  
  private func presentAlert() {
    let alert = UIAlertController(
      title: "Fail",
      message: "Application was unable to gather data.",
      preferredStyle: .alert)
    
    let ok = UIAlertAction(
      title: "Ok",
      style: .default)
    
    alert.addAction(ok)
    present(alert, animated: true)
  }
}

// MARK: - UICollectionViewDataSource

extension MainViewController {
  
  override func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    
    burgerJointsWithPhoto.count
  }
  
  override func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
  
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: CellIdentifier.venueCollectionViewCellId,
      for: indexPath
      ) as! VenueCollectionViewCell
    
    let viewModel = burgerJointsWithPhoto[indexPath.item]
    if let photo = viewModel.photo {
      cell.setup(with: photo, networking: networking)
    }
    
    return cell
  }
  
  override func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    
    let cell = collectionView.dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: CellIdentifier.mapHeaderId,
      for: indexPath) as! MapHeaderView
    
    cell.mapView = mapView
    cell.loadingLabel = loadingLabel
    
    return cell
  }
}
