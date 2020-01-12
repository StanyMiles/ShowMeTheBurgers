//
//  Networking.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 26.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct Networking {
  
  private typealias NetworkResponse = (data: Data?, response: URLResponse?, error: Swift.Error?)
  
  // MARK: - Properties
  
  private let clientId: String
  private let clientSecret: String
  private let apiVersion: String
  private let urlSession: URLSession
  
  private let mainAPIBaseUrl = "https://api.foursquare.com/v2/venues/"
  private let burgerRecognitionBaseUrl = "https://pplkdijj76.execute-api.eu-west-1.amazonaws.com/prod/recognize"
  
  private var baseQueryItems: [URLQueryItem] {
    [URLQueryItem(name: QueryItemName.clientId, value: clientId),
     URLQueryItem(name: QueryItemName.clientSecret, value: clientSecret),
     URLQueryItem(name: QueryItemName.version, value: apiVersion)]
  }
  
  // MARK: - Initializers
  
  init(
    clientId: String = APISecretKeys.clientId,
    clientSecret: String = APISecretKeys.clientSecret,
    apiVersion: String = APIKeys.version,
    urlSession: URLSession = .shared
  ) {
    self.clientId     = clientId
    self.clientSecret = clientSecret
    self.apiVersion   = apiVersion
    self.urlSession   = urlSession
  }
  
  // MARK: - Funcs
  
  @discardableResult
  func requestVenues(
    atLocation location: String,
    categoryId: String,
    intent: String,
    completion: @escaping (Result<[Venue], Error>) -> Void
  ) -> URLSessionDataTask? {
    
    let urlString = "\(mainAPIBaseUrl)\(UrlPath.search)"
    
    var components = URLComponents(string: urlString)
    var queryItems = [
      URLQueryItem(name: QueryItemName.near, value: location),
      URLQueryItem(name: QueryItemName.categoryId, value: categoryId),
      URLQueryItem(name: QueryItemName.intent, value: intent),
    ]
    queryItems.append(contentsOf: baseQueryItems)
    components?.queryItems = queryItems
    
    guard let url = components?.url else {
      completion(.failure(.damagedURL))
      return nil
    }
    
    let dataTask = urlSession.dataTask(with: url) { data, response, error in
      
      let result = self.getData(from: (data, response, error))
      
      switch result {
      case .success(let data):
        
        do {
          let mainResponse = try JSONDecoder().decode(APIMainReponse.self, from: data)
          
          guard let venues = mainResponse.response.venues else {
            completion(.failure(.noData))
            return
          }
          
          completion(.success(venues))
          
        } catch {
          completion(.failure(.unableToDecode))
        }
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
    
    dataTask.resume()
    return dataTask
  }
  
  @discardableResult
  func requestVenues(
    atCoordinates coordinates: Coordinates,
    radius: Int = 1000,
    categoryId: String = APIKeys.categoryId,
    intent: String = APIKeys.intent,
    completion: @escaping (Result<[Venue], Error>) -> Void
  ) -> URLSessionDataTask? {
    
    let urlString = "\(mainAPIBaseUrl)\(UrlPath.search)"
    
    var components = URLComponents(string: urlString)
    var queryItems = [
      URLQueryItem(name: QueryItemName.radius, value: String(radius)),
      URLQueryItem(name: QueryItemName.categoryId, value: categoryId),
      URLQueryItem(name: QueryItemName.intent, value: intent),
      URLQueryItem(
        name: QueryItemName.coordinates,
        value: "\(coordinates.latitude),\(coordinates.longitude)"),
    ]
    queryItems.append(contentsOf: baseQueryItems)
    components?.queryItems = queryItems
    
    guard let url = components?.url else {
      completion(.failure(.damagedURL))
      return nil
    }
    
    let dataTask = urlSession.dataTask(with: url) { data, response, error in
      
      let result = self.getData(from: (data, response, error))
      
      switch result {
      case .success(let data):
        
        do {
          let mainResponse = try JSONDecoder().decode(APIMainReponse.self, from: data)
          
          guard let venues = mainResponse.response.venues else {
            completion(.failure(.noData))
            return
          }
          
          completion(.success(venues))
          
        } catch {
          completion(.failure(.unableToDecode))
        }
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
    
    dataTask.resume()
    return dataTask
  }
  
  @discardableResult
  func requestPhoto(
    for venueId: String,
    group: String = APIKeys.group,
    limit: Int = 1,
    completion: @escaping (Result<Photo, Error>) -> Void
  ) -> URLSessionDataTask? {
    
    let urlString = "\(mainAPIBaseUrl)\(venueId)/\(UrlPath.photos)"
    
    var components = URLComponents(string: urlString)
    var queryItems = [
      URLQueryItem(name: QueryItemName.group, value: group),
      URLQueryItem(name: QueryItemName.limit, value: String(limit)),
    ]
    queryItems.append(contentsOf: baseQueryItems)
    components?.queryItems = queryItems
    
    guard let url = components?.url else {
      completion(.failure(.damagedURL))
      return nil
    }
    
    let dataTask = urlSession.dataTask(with: url) { data, response, error in
      
      let result = self.getData(from: (data, response, error))
      
      switch result {
      case .success(let data):
        
        do {
          let mainResponse = try JSONDecoder().decode(APIMainReponse.self, from: data)
          
          guard let photo = mainResponse.response.photos?.items.first else {
            completion(.failure(.noData))
            return
          }
          
          completion(.success(photo))
          
        } catch {
          completion(.failure(.unableToDecode))
        }
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
    
    dataTask.resume()
    
    return dataTask
  }
  
  @discardableResult
  func downloadImageData(
    withURL url: URL,
    completion: @escaping (Result<Data, Error>) -> Void
  ) -> URLSessionDataTask {
    
    let dataTask = urlSession.dataTask(with: url) { data, response, error in
      
      let result = self.getData(from: (data, response, error))
      
      switch result {
      case .success(let data):
        completion(.success(data))
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
    
    dataTask.resume()
    return dataTask
  }
  
  @discardableResult
  func recognizeBurgerOnImage(
    at url: String,
    completion: @escaping (Bool) -> Void
  ) -> URLSessionDataTask {
    
    recognizeBurgerOnImages(
      at: [url]
    ) { urlWithBurger in
      completion(url == urlWithBurger)
    }
  }
  
  @discardableResult
  func recognizeBurgerOnImages(
    at urls: [String],
    completion: @escaping (String?) -> Void
  ) -> URLSessionDataTask {
    
    struct Request: Encodable {
      let urls: [String]
    }
    
    let url = URL(string: burgerRecognitionBaseUrl)!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try! JSONEncoder().encode(Request(urls: urls))
    
    let dataTask = urlSession.dataTask(with: request) { data, response, error in
      
      let result = self.getData(from: (data, response, error))

      switch result {
      case .success(let data):

        struct Response: Decodable {
          let urlWithBurger: String
        }

        do {
          let result = try JSONDecoder().decode(Response.self, from: data)
          completion(result.urlWithBurger)

        } catch {
          completion(nil)
        }

      case .failure:
        completion(nil)
      }
    }
    
    dataTask.resume()
    return dataTask
  }
}

// MARK: - QueryItemName

extension Networking {
  
  private enum QueryItemName {
    static let clientId     = "client_id"
    static let clientSecret = "client_secret"
    static let version      = "v"
    static let near         = "near"
    static let categoryId   = "categoryId"
    static let coordinates  = "ll"
    static let intent       = "intent"
    static let radius       = "radius"
    static let group        = "group"
    static let limit        = "limit"
  }
}

// MARK: - UrlPath

extension Networking {
  private enum UrlPath {
    static let photos = "photos"
    static let search = "search"
  }
}

// MARK: - Helpers

extension Networking {
  
  private func handleNetworkResponse(_ response: HTTPURLResponse) -> Error? {
    switch response.statusCode {
    case 200...299: return nil
    case 401...500: return .authenticationError
    case 501...599: return .badRequest
    case 600:       return .outdated
    default:        return .failed
    }
  }
  
  private func getData(from response: NetworkResponse) -> Result<Data, Error> {
    
    let (d, r, e) = response
    
    if let error = e {
      return .failure(.internalError(error))
    }
    
    guard let response = r as? HTTPURLResponse else {
      return .failure(.failed)
    }
    
    if let error = self.handleNetworkResponse(response) {
      return .failure(error)
    }
    
    guard let data = d else {
      return .failure(.noData)
    }
    
    return .success(data)
  }
}

// MARK: - Errors

extension Networking {
  
  enum Error: Swift.Error {
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
    case internalError(Swift.Error?)
    case damagedURL
  }
}
