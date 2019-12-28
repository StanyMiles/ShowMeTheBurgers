//
//  DetailViewController.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 28.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  // MARK: - Initialization
  
  class func instantiate(
    with photo: Photo?,
    title: String,
    networking: Networking = Networking()
  ) -> UIViewController {
    
    let viewController = DetailViewController.instantiate()
    viewController.photo = photo
    viewController.navigationItem.title = title
    viewController.networking = networking
    return viewController
  }
  
  // MARK: - IBOutlets
  
  @IBOutlet private weak var imageView: UIImageView!
  
  // MARK: - Properties
  
  var photo: Photo?
  var networking: Networking!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    assert(networking != nil, "Must be set before initialization")
    
    navigationController?.navigationBar.prefersLargeTitles = true
    downloadImageData()
  }
  
  // MARK: - Funcs
  
  private func downloadImageData() {
    guard let url = photo?.makeUrl(forSize: .large) else {
      imageView.image = .photoPlaceholder
      return
    }
    
    networking.downloadImageData(
      withURL: url
    ) { [weak self] result in
      
      guard let self = self else { return }
      
      DispatchQueue.main.async {
        
        switch result {
        case .success(let data):
          self.imageView.image = UIImage(data: data) ?? .photoPlaceholder
          
        case .failure(let error):
          self.imageView.image = .photoPlaceholder
          
          #if DEBUG
          print("Failed to load image data:", error)
          #endif
        }
      }
    }
  }
}

// MARK: - StoryboardInstantiable

extension DetailViewController: StoryboardInstantiable { }
