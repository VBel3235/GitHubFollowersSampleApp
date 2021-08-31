//
//  PersistanceManager.swift
//  GHFollowers
//
//  Created by Владислав Белов on 30.08.2021.
//

import Foundation

enum PersistanceActionType {
    case add, remove
}

enum PersistanceManager {
    static private let defaults = UserDefaults.standard
    
    enum keys{
        static let favourites = "favourites"
    }
    
    static func retrieveFavourites(completion: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favouritesData = defaults.object(forKey: keys.favourites) as? Data else {
            completion(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let favourites = try decoder.decode([Follower].self, from: favouritesData)
            completion(.success(favourites))
        } catch  {
            completion(.failure(.unableToFavourite))
        }
    }
    
    static func save(favourites: [Follower]) -> GFError?{
        do {
            let encoder = JSONEncoder()
            let encodedFavourites = try encoder.encode(favourites)
            defaults.setValue(encodedFavourites, forKey: keys.favourites)
            return nil
        } catch  {
            return .unableToFavourite
        }
    }
    
    static func update(favourite: Follower, actionType: PersistanceActionType, completion: @escaping (GFError?) -> Void){
        retrieveFavourites { result in
            switch result{
            case .success(var favourites):
               
                switch actionType {
                case .add:
                    guard !favourites.contains(favourite) else {
                        completion(.alreadyInFavourite)
                        return
                    }
                    favourites.append(favourite)
                    
                    break
                case .remove:
                    favourites.removeAll { $0.login == favourite.login}
                }
                completion(save(favourites: favourites))
                
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
}
