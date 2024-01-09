//
//  PostListViewModel.swift
//  iosArchitecture
//
//  Created by Grigory Sapogov on 31.12.2023.
//

import Foundation

protocol IPostListViewModel: AnyObject {
    
    var updateCompletion: ((Error?) -> Void)? { get set }
    
    var posts: [IPost] { get }
    
    func update()
    
    func fetchFromStorage()
    
}

final class PostListViewModel: IPostListViewModel {
    
    private(set) var posts: [IPost] = []
    
    private let api: IApi
    
    private let storage: IStorage
    
    var updateCompletion: ((Error?) -> Void)?
    
    init(api: IApi = Api(),
         storage: IStorage) {
        self.api = api
        self.storage = storage
    }
    
    func update() {
        
        self.api.fetchApiData { [weak self] result in
            
            switch result {
            case let .failure(error):
                
                DispatchQueue.main.async {
                    self?.updateCompletion?(error)
                }
                
            case let .success(array):
                
                self?.storage.saveToStorage(array: array) { error in
                    
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.updateCompletion?(error)
                        }
                        return
                    }

                    self?.fetchFromStorage()
                    
                }
                
            }
            
        }
        
    }
    
    func fetchFromStorage() {
        
        self.storage.fetchFromStorage { [weak self] result in
            
            switch result {
            case let .failure(error):
                DispatchQueue.main.async {
                    self?.updateCompletion?(error)
                }
            case let .success(posts):
                self?.posts = posts
                DispatchQueue.main.async {
                    self?.updateCompletion?(nil)
                }
            }
            
        }
        
    }
    
    
}
