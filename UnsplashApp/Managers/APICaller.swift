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
    
    // MARK: - search
    public func search(with query: String, completion: @escaping (Result<SearchRequestResults, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL+"search/photos?page=1&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&per_page=40"),
            type: .GET) { request in
                print(request.url?.absoluteString ?? "none")
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    
                    do {
                        let results = try JSONDecoder().decode(SearchRequestResults.self, from: data)
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
