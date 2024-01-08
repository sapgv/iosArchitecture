//
//  UserDefaultStorage.swift
//  IosSolid
//
//  Created by Grigory Sapogov on 23.12.2023.
//

import Foundation

final class UserDefaultStorage: IStorage {
    
    static let postKey = "posts"
    
    static let favouriteKey = "favourite"
    
    func saveToStorage(array: [[String: Any]], completion: @escaping (Error?) -> Void) {
        
        DispatchQueue.global().async {
            
            do {
                
                let posts = array.map { Post(data: $0) }
                
                let encoder = JSONEncoder()
                
                let encoded = try encoder.encode(posts)
                
                UserDefaults.standard.set(encoded, forKey: Self.postKey)
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
                
                guard let data = UserDefaults.standard.object(forKey: Self.postKey) as? Data else {
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
        
        self.fetchFavourites { result in
            
            switch result {
            case let .failure(error):
                completion(error)
            case let .success(posts):
                
                DispatchQueue.global().async {
                    
                    do {
                        
                        guard let post = post as? Post else {
                            DispatchQueue.main.async {
                                completion(StorageError.saveFailure("Post favourite"))
                            }
                            return
                        }
                        
                        var posts = posts as? [Post] ?? []
                        
                        if !posts.contains(where: { $0.id == post.id }) {
                            posts.append(post)
                        }
                        
                        let encoder = JSONEncoder()

                        let encoded = try encoder.encode(posts)

                        UserDefaults.standard.set(encoded, forKey: Self.favouriteKey)
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
            
        }
        
        
    }
    
    func fetchFavourites(completion: @escaping (Swift.Result<[IPost], Error>) -> Void) {
        
        DispatchQueue.global().async {
            
            do {
                
                guard let data = UserDefaults.standard.object(forKey: Self.favouriteKey) as? Data else {
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
    
    func isFavourite(post: IPost, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        
        self.fetchFavourites { result in
            
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(posts):
                
                DispatchQueue.global().async {
                    
                    let favouriteIds = posts.map { $0.id }
                    
                    let isFavourite = favouriteIds.contains(post.id)
                    
                    DispatchQueue.main.async {
                        completion(.success(isFavourite))
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
}
