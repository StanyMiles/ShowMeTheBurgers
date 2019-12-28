//
//  VenueCollectionViewCell.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 26.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class VenueCollectionViewCell: UICollectionViewCell {
  
  // MARK: - IBOutlets
  
  @IBOutlet private weak var imageView: UIImageView!
  
  // MARK: - Properties
  
  private var dataTask: URLSessionDataTask?
  
  // MARK: - Lifecycle
  
  override func prepareForReuse() {
    super.prepareForReuse()
    dataTask?.cancel()
    dataTask = nil
    imageView.image = nil
    imageView.layer.borderWidth = 0
    imageView.layer.borderColor = UIColor.clear.cgColor
  }
  
  // MARK: - Funcs
  
  func setup(with photo: Photo, networking: NetworkingFacade) {
    
    guard let url = photo.makeUrl(forSize: .medium) else { return }
    
    dataTask = networking.downloadImageData(
      withURL: url
    ) { [weak self] result in
      
      guard let self = self else { return }
      
      switch result {
      case .success(let data, let hasBurger):
        
        DispatchQueue.main.async {
          if let image = UIImage(data: data) {
            self.set(image, withBorder: hasBurger)
          } else {
            self.set(.photoPlaceholder, withBorder: false)
          }
        }
        
      case .failure:
        break
      }
    }
  }
  
  private func set(_ image: UIImage?, withBorder: Bool) {
    imageView.image = image
    if withBorder {
      imageView.layer.borderWidth = 5
      imageView.layer.borderColor = UIColor.red.cgColor
    }
  }
}
