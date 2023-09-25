//
//  NetworkManager.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 14.03.23.
//

import Foundation
import Alamofire

enum NetworkError: String, Error {
    case invalidUrl = "Invalid URL"
    case invalidImageUrl = "Invalid image URL"
    case invalidData = "Invalid data"
    case invalidImageData = "No umage data found"
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
// MARK: - Apple networking: @Escaping approach
// CODE HAS NOT BEEN REFACTORED
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
    
    func createUrl(host: String, path: String, query: [URLQueryItem]? = nil) -> URL? {
        var components = URLComponents(string: host)
        components?.path = path
        components?.queryItems = query
        
        return components?.url
    }
    
// MARK: - Apple networking: Async/Await approach
    func fetchImageData(from url: String) async throws -> Data? {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidImageUrl
        }
        guard let imageData = try? Data(contentsOf: url) else {
            throw NetworkError.invalidImageData
        }
        return imageData
    }
    
    func fetchData<T: Decodable>(_ type: T.Type, using request: URLRequest) async throws -> T {
        guard let url = request.url else {
            print(NetworkError.invalidUrl.rawValue)
            throw NetworkError.invalidUrl
        }
        
        // TODO: - Реализовать аутентификацию (через делагат?)
        guard let (data, response) = try? await URLSession.shared.data(from: url) else {
            print(NetworkError.invalidData.rawValue)
            throw NetworkError.invalidData
        }
        print(request.headers)
        print(response.url ?? "")
        
        guard let decodedData = try? JSONDecoder().decode(type, from: data) else {
            print(APIError.jsonDecodingError.rawValue)
            throw APIError.jsonDecodingError
        }
        
        return decodedData
    }
    
// MARK: - Alamofire networking
// CODE HAS NOT BEEN REFACTORED
//    func fetchAFData(using url: String, completion: @escaping (Result<Data, AFError>) -> Void) {
//        AF.request(url)
//            .validate()
//            .responseData { response in
//                switch response.result {
//                case .success(let data): completion(.success(data))
//                case .failure(let error): completion(.failure(error))
//                }
//            }
//    }
//
//    func fetchAFData(using request: URLRequest, completion: @escaping (Result<Any, AFError>) -> Void)
//    {
//        AF.request(request)
//            .validate()
//            .responseJSON { response in
//                switch response.result {
//                case .success(let data): completion(.success(data))
//                case .failure(let error): completion(.failure(error))
//                }
//            }
//    }

}
