//
//  PostStorage.swift
//  IosSolid
//
//  Created by Grigory Sapogov on 23.12.2023.
//

import Foundation

final class PostStorage: IStorage {
    
    private let postKey = "posts"

    private let favouriteKey = "favourite"
    
    private var favouritesIds: [Int] {
        self.favourites.map { $0.id }
    }
    
    private var favourites: Set<Post> {
        get {
            guard let data = UserDefaults.standard.object(forKey: self.favouriteKey) as? Data else { return [] }
            let decoder = JSONDecoder()
            let posts = try? decoder.decode(Set<Post>.self, from: data)
            return posts ?? Set<Post>()
        }
        set {
            let encoder = JSONEncoder()
            let encoded = try? encoder.encode(newValue)
            UserDefaults.standard.set(encoded, forKey: self.favouriteKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    func saveToStorage(array: [[String: Any]], completion: @escaping (Error?) -> Void) {
        
        DispatchQueue.global().async {
            
            do {
                
                let posts = array.map { Post(data: $0) }
                
                let encoder = JSONEncoder()
                
                let encoded = try encoder.encode(posts)
                
                UserDefaults.standard.set(encoded, forKey: self.postKey)
                UserDefaults.standard.synchronize()
                
                DispatchQueue.main.async {
                    completion(nil)
                }
                
            }
            catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
            
        }
        
    }
    
    
    func fetchFromStorage(completion: @escaping (Swift.Result<[IPost], Error>) -> Void) {
        
        DispatchQueue.global().async {
            
            do {
                
                guard let data = UserDefaults.standard.object(forKey: self.postKey) as? Data else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                
                let decoder = JSONDecoder()
                
                let posts = try decoder.decode([Post].self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(posts))
                }
                
            }
            catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }
        
    }
    
    func addToFavourite(post: IPost, completion: @escaping (Error?) -> Void) {
        
        DispatchQueue.global().async {
            
            if let post = post as? Post {
                self.favourites.insert(post)
            }

            DispatchQueue.main.async {
                completion(nil)
            }
            
        }
        
    }
    
    func fetchFavourites(completion: @escaping (Swift.Result<[IPost], Error>) -> Void) {
        
        DispatchQueue.global().async {
            
            let favourites = self.favourites
            
            let array = Array(favourites)
            
            DispatchQueue.main.async {
                completion(.success(array))
            }
            
        }
        
    }
    
    func isFavourite(post: IPost) -> Bool {
        
        self.favouritesIds.contains(post.id)
        
    }
    
}
