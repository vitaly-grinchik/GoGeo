//
//  NetworkManager.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 14.03.23.
//

import Foundation
import Alamofire

struct Resource {
    let host: String
    let endpoint: String
    let query: [URLQueryItem]?
    
    var url: URL? {
        if var components = URLComponents(string: host) {
            components.path = endpoint
            components.queryItems = query
            if let url = components.url { return url }
        }
        return nil
    }
}

enum DataModel {
    case countrySearch
    case countryDetails
}

enum RapidApi: String {
    case host = "https://wft-geo-db.p.rapidapi.com"
    case country = "/v1/geo/countries"
    case city = "/v1/geo/cities"
}

enum NetError: String, Error {
    case invalidData = "Invalid data"
    case invalidUrl = "Invalid URL"
    case requestFailed = "Request failed"
    case decodeError = "JSON decoding error"
    case noImageData = "No umage data found"
    case jsonIncompatible = "JSON incompatibility error"
}

class NetworkManager {
    static let shared = NetworkManager()
    
    // RapidAPI Key
    let rapidHeaders = [
        "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com",
        "X-RapidAPI-Key": "3d736771d3msh14a3562b22f1641p1af6f7jsn1b7fcb2fc09b"
    ]
    
    private init() {}
    
    // Apple networking
//    func fetchImageData(from url: String, completion: @escaping (Result<Data, NetError>) -> Void) {
//        guard let url = URL(string: url) else {
//            completion(.failure(.invalidUrl))
//            return
//        }
//
//        DispatchQueue.global().async {
//            guard let imageData = try? Data(contentsOf: url) else {
//                completion(.failure(.noImageData))
//                return
//            }
//            DispatchQueue.main.async {
//                completion(.success(imageData))
//            }
//        }
//    }
//
//    func fetchData<T: Decodable>(_ type: T.Type, using request: URLRequest, completion: @escaping (Result<T, NetError>) -> Void) {
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let _ = error {
//                if let serverResponse = response as? HTTPURLResponse {
//                    let code = serverResponse.statusCode
//                    print(NetError.requestFailed.rawValue)
//                    print(HTTPURLResponse.localizedString(forStatusCode: code))
//                }
//                completion(.failure(.requestFailed))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(.invalidData))
//                return
//            }
//
//            if let data = try? JSONDecoder().decode(type, from: data) {
//                DispatchQueue.main.async {
//                    completion(.success(data))
//                }
//            } else {
//                completion(.failure(.decodeError))
//            }
//        }.resume()
//    }
    
    // Alamofire networking
    func fetchAFImageData(from url: String, completion: @escaping (Result<Data, AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data): completion(.success(data))
                case .failure(let error): completion(.failure(error))
                }
            }
    }
    
    func fetchAFData<T>(for type: T.Type,
                      using request: URLRequest,
                      compleation: @escaping (Result<T, NetError>) -> Void)
    {
        // Key name for data in Model
        let dataKey = "data"
        
        AF.request(request)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let responseData):
                    // Check if data are JSON format compatible
                    guard let jsonData = responseData as? [String: Any] else {
                        compleation(.failure(.jsonIncompatible))
                        return
                    }
                    // Check for presence of needed key in JSON response
                    guard jsonData.keys.contains(dataKey) else {
                        compleation(.failure(.invalidData))
                        return
                    }
                     
                    if type == CountrySearch.self {
                        // Check if data conforms to CountrySearch model
                        guard let data = jsonData[dataKey] as? [[String: Any]] else {
                            compleation(.failure(.invalidData))
                            return
                        }
                        // Parse values
                        guard let countrySearch = CountrySearch(data: data) as? T else {
                            compleation(.failure(.invalidData))
                            return
                        }
                        compleation(.success(countrySearch))
                        
                    } else if type == CountryWithId.self {
                        // Check if data conforms to CountryDetails model
                        guard let data = jsonData[dataKey] as? [String: Any] else {
                            compleation(.failure(.invalidData))
                            return
                        }
                        // Parse values
                        guard let countryDetails = CountryWithId(data: data) as? T else {
                            compleation(.failure(.decodeError))
                            return
                        }
                        compleation(.success(countryDetails))
                        
                    } else {
                        compleation(.failure(.invalidData))
                        return
                    }

                case .failure(_): compleation(.failure(.invalidData))
                }
            }
    }
    
//    func searchCountries(using request: URLRequest, compleation: @escaping (Result<CountrySearch, NetError>) -> Void) {
//        
//        // Key name for data in Model
//        let dataKey = "data"
//        
//        AF.request(request)
//            .validate()
//            .responseJSON { response in
//                switch response.result {
//                case .success(let responseData):
//                    // Check for global JSON complatability
//                    guard let jsonData = responseData as? [String: Any] else {
//                        compleation(.failure(.jsonIncompatible))
//                        return
//                    }
//                    // Check for presence of needed key in JSON response
//                    guard jsonData.keys.contains(dataKey) else {
//                        compleation(.failure(.invalidData))
//                        return
//                    }
//                    
//                    // Check if data is compatible with the CountrySearch model
//                    guard let data = jsonData[dataKey] as? [[String: Any]] else {
//                        compleation(.failure(.invalidData))
//                        return
//                    }
//                    
//                    // Parse values
//                    let countrySearch = CountrySearch(data: data)
//                    compleation(.success(countrySearch))
//                    return
//                    
//                case .failure(_):
//                    print(NetError.invalidData.rawValue)
//                    compleation(.failure(.invalidData))
//                }
//            }
//    }

}
