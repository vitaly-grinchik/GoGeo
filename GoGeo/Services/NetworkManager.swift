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
    case countryBrief
    case countryDetails
    case countryWithId
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
    case jsonIncompatible = "JSON incompatibility err0r"
}

class NetworkManager {
    static let shared = NetworkManager()
    
    // RapidAPI Key
    let rapidHeaders = [
        "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com",
        "X-RapidAPI-Key": "3d736771d3msh14a3562b22f1641p1af6f7jsn1b7fcb2fc09b"
    ]
    
    private init() {}
    
    func fetchImageData(from url: String, completion: @escaping (Result<Data, NetError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noImageData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    
    func fetchAFData(from url: String, completion: @escaping (Result<Data, AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data): completion(.success(data))
                case .failure(let error): completion(.failure(error))
                }
            }
    }
    
    func fetchData<T: Decodable>(_ type: T.Type, using request: URLRequest, completion: @escaping (Result<T, NetError>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                if let serverResponse = response as? HTTPURLResponse {
                    let code = serverResponse.statusCode
                    print(NetError.requestFailed.rawValue)
                    print(HTTPURLResponse.localizedString(forStatusCode: code))
                }
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                print(NetError.invalidData.rawValue)
                completion(.failure(.invalidData))
                return
            }
            
            if let data = try? JSONDecoder().decode(type, from: data) {
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            } else {
                completion(.failure(.decodeError))
            }
        }.resume()
    }
    
    func fetchCountries(using request: URLRequest, compleation: @escaping (Result<CountrySearch, NetError>) -> Void) {
        
        // Key name for data in Model
        let dataKey = "data"
        
        AF.request(request)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    // Check for global JSON complatability
                    guard let searchResult = data as? [String: Any] else {
                        compleation(.failure(.jsonIncompatible))
                        return
                    }
                    // Check for presence of needed key in JSON response
                    guard searchResult.keys.contains(dataKey) else {
                        compleation(.failure(.decodeError))
                        return
                    }
                    // Get values for needed key
                    guard let values = searchResult[dataKey] else { return }
                    
                    // Check if data value is an array type in accordance with the model
                    guard let countriesData = values as? [[String: Any]] else {
                        compleation(.failure(.jsonIncompatible))
                        return
                    }
                    
                    // Parse values
                    let countries = CountrySearch(data: countriesData)
                    compleation(.success(countries))
                    return
                    
                case .failure(_):
                    print(NetError.invalidData.rawValue)
                    compleation(.failure(.invalidData))
                }
            }
    }

}
