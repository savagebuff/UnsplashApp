//
//  APICaller.swift
//  UnsplashApp
//
//  Created by Dinar Garaev on 04.06.2022.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "https://api.unsplash.com/"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    // MARK: - random photo
    public func fetchRandomPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL+"photos/random?orientation=portrait&count=30"),
            type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    
                    do {
                        let results = try JSONDecoder().decode([Photo].self, from: data)
                        completion(.success(results))
                    } catch let error as NSError {
                        print("try! "+error.localizedDescription)
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
    }
    
    // MARK: - search
    public func search(with query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL+"search/photos?page=1&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&per_page=30"),
            type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    
                    do {
                        let results = try JSONDecoder().decode(SearchResponse.self, from: data)
                        completion(.success(results))
                        
                    } catch let error as NSError {
                        print("try! "+error.localizedDescription)
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
    }
    
    // MARK: - private
    private func createRequest(
        with url: URL?,
        type: HTTPMethod,
        completion: @escaping (URLRequest) -> Void
    ) {
        guard let apiURL = url else {
            return
        }
        var request = URLRequest(url: apiURL)
        request.setValue("Client-ID AelwVUxCQSt8SbnNeH2T02bBh5CDlzN4Ut47Rlcyv6I", forHTTPHeaderField: "Authorization")
        request.httpMethod = type.rawValue
        completion(request)
    }
}
