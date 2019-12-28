//
//  NetworkingFacade.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 27.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import UIKit

struct NetworkingFacade {
  
  // MARK: - Properties
  
  private let networking: Networking
  
  // MARK: - Initializer
  
  init(networking: Networking = Networking()) {
    self.networking = networking
  }
  
  // MARK: - Funcs
  
  func requestFilteredBurgerJoints(
    at location: String = APIKeys.location,
    excludedAreaCenter: Coordinates,
    filteredRadius: Int = 1000,
    categoryId: String = APIKeys.categoryId,
    intent: String = APIKeys.intent,
    completion: @escaping (Result<[BurgerJointViewModel], Error>) -> Void
  ) {
    
    networking.requestVenues(
      atLocation: location,
      categoryId: categoryId,
      intent: intent
    ) { result in
        
      switch result {
      case .success(let allVenues):
        
        self.networking.requestVenues(
          atCoordinates: excludedAreaCenter,
          radius: filteredRadius,
          categoryId: categoryId,
          intent: intent
        ) { result in
            
          switch result {
          case .success(let excludedVenues):
            let filteredVenues = allVenues.filter { !excludedVenues.contains($0) }
            
            self.downloadImages(for: filteredVenues) { burgerJoints in
              completion(.success(burgerJoints))
            }
            
          case .failure(let error):
            completion(.failure(error))
          }
        }
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  @discardableResult
  func downloadImageData(
    withURL url: URL,
    completion: @escaping (Result<(Data, Bool), Error>) -> Void
  ) -> URLSessionDataTask {
    
    let group = DispatchGroup()
    
    var imageData: Data?
    var hasBurgerOnImage = false
    
    group.enter()
    let dataTask = networking.downloadImageData(
      withURL: url
    ) { result in
      
      switch result {
      case .success(let data):
        imageData = data
      case .failure:
        break
      }
      
      group.leave()
    }
    
    group.enter()
    networking.recognizeBurgerOnImage(
      at: url.absoluteString
    ) { hasBurger in
      hasBurgerOnImage = hasBurger
      group.leave()
    }
      
    group.notify(queue: .global()) {
      if let data = imageData {
        let result = (data, hasBurgerOnImage)
        completion(.success(result))
      } else {
        completion(.failure(Networking.Error.noData))
      }
    }
    
    return dataTask
  }
  
  // MARK: - Private Funcs
  
  private func downloadImages(
    for venues: [Venue],
    completion: @escaping ([BurgerJointViewModel]) -> Void
  ) {
    
    let group = DispatchGroup()
    
    var burgerJoints: [BurgerJointViewModel] = []
    
    for venue in venues {
      group.enter()
      
      networking.requestPhoto(for: venue.id) { result in
        
        var photo: Photo?
        
        switch result {
        case .success(let p):
          photo = p
        case .failure(let err):
          #if DEBUG
          print("Faied to download photo:", err)
          #endif
        }
        
        let joint = BurgerJointViewModel(venue: venue, photo: photo)
        burgerJoints.append(joint)
        
        group.leave()
      }
    }
    
    group.notify(queue: .global()) {
      completion(burgerJoints)
    }
  }
  
}
