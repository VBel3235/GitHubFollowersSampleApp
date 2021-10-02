//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Владислав Белов on 13.07.2021.
//

import UIKit

class NetworkManager{
    
    static let shared                           = NetworkManager()
   private let baseURL: String                  = "https://api.github.com/users"
    let cache = NSCache<NSString, UIImage>()
    let decoder = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func getUserName(for username: String, completion: @escaping (Result<User, GFError>) -> Void){
        let endPoint = baseURL + "/\(username)"
        
        guard let url = URL(string: endPoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
        
                let user = try self.decoder.decode(User.self, from: data)
                completion(.success(user))
            }
            catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
//    func getFollowers(username: String, page: Int, completion: @escaping (Result<[Follower], GFError>) -> Void){
//        let endPoint = baseURL + "/\(username)/followers?per_page=100&page=\(page)"
//
//        guard let url = URL(string: endPoint) else {
//            completion(.failure(.invalidUsername))
//            return
//        }
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let _ = error{
//                completion(.failure(.unableToComplete))
//            }
//
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completion(.failure(.invalidResponse))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(.invalidData))
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let followers = try decoder.decode([Follower].self, from: data)
//                completion(.success(followers))
//            }
//            catch {
//                completion(.failure(.invalidData))
//            }
//        }
//
//        task.resume()
//    }
    
    func getFollowers(username: String, page: Int) async throws -> [Follower]{
        let endPoint = baseURL + "/\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endPoint) else {
            throw GFError.invalidUsername
            
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }
        do {
            return try decoder.decode([Follower].self, from: data)
        }
        catch {
            throw GFError.invalidData
        }
    }
    
    
    
    
    
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void){
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey){
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
            
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, error == nil,
            let response = response as? HTTPURLResponse, response.statusCode == 200,
            let data = data,
            let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            DispatchQueue.main.async {
               completion(image)
            }
            
        }
        task.resume()
    }
}
