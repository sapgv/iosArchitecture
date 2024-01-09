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
    
    private var favouritesIds: [Int] = []
    
    init() {
        self.updateFavouritesIds()
        NotificationCenter.default.addObserver(self, selector: #selector(favouritesDidChange), name: .favouritesDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private var favouritesSet: Set<Post> {
        return Set<Post>(self.favourites)
    }
    
    private var favourites: [Post] {
        get {
            guard let data = UserDefaults.standard.object(forKey: self.favouriteKey) as? Data else { return [] }
            let decoder = JSONDecoder()
            let posts = try? decoder.decode([Post].self, from: data)
            return posts ?? []
        }
        set {
            let encoder = JSONEncoder()
            let encoded = try? encoder.encode(newValue)
            UserDefaults.standard.set(encoded, forKey: self.favouriteKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: .favouritesDidChange, object: nil)
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
    
    func fetchFavourites(completion: @escaping (Swift.Result<[IPost], Error>) -> Void) {
        
        DispatchQueue.global().async {
            
            let favourites = self.favouritesSet
            
            let array = Array(favourites)
            
            DispatchQueue.main.async {
                completion(.success(array))
            }
            
        }
        
    }
    
    func addToFavourite(post: IPost, completion: @escaping (Error?) -> Void) {
        
        DispatchQueue.global().async {
            
            if let post = post as? Post, !self.favourites.contains(post) {
                self.favourites.append(post)
            }

            DispatchQueue.main.async {
                completion(nil)
            }
            
        }
        
    }
    
    func removeFromFavourite(post: IPost, completion: @escaping (Error?) -> Void) {
        
        DispatchQueue.global().async {
            
            if let post = post as? Post {
                self.favourites.removeAll(where: { $0.id == post.id })
            }

            DispatchQueue.main.async {
                completion(nil)
            }
            
        }
        
    }
    
    func isFavourite(post: IPost) -> Bool {
        
        self.favouritesIds.contains(post.id)
        
    }
    
    private func updateFavouritesIds() {
        self.favouritesIds = self.favouritesSet.map { $0.id }
    }
    
    @objc
    private func favouritesDidChange() {
        self.updateFavouritesIds()
    }
    
}
