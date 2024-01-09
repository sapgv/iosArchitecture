//
//  PostListPresenter.swift
//  IosSolid
//
//  Created by Grigory Sapogov on 23.12.2023.
//

import Foundation

protocol IPostListPresenter: AnyObject {

    var view: IPostListViewController? { get set }
    
    var posts: [IPost] { get }
    
    func update()
    
    func fetchFromStorage()
    
    func addToFavourite(post: IPost)
    
    func removeFromFavourite(post: IPost)
    
    func isFavourite(post: IPost) -> Bool
    
}

final class PostListPresenter: IPostListPresenter {
    
    weak var view: IPostListViewController?
    
    private(set) var posts: [IPost] = []
    
    private let api: IApi
    
    private let storage: IStorage
    
    init(api: IApi = Api(),
         storage: IStorage = PostStorage()) {
        self.api = api
        self.storage = storage
    }
    
    func update() {
        
        self.api.fetchApiData { [weak self] result in
            
            switch result {
            case let .failure(error):
                
                DispatchQueue.main.async {
                    self?.view?.showError(error: error)
                }
                
            case let .success(array):
                
                self?.storage.saveToStorage(array: array) { error in
                    
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.view?.showError(error: error)
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
                self?.view?.showError(error: error)
            case let .success(posts):
                self?.posts = posts
                self?.view?.updateView()
            }
            
        }
        
    }
    
    func addToFavourite(post: IPost) {
        
        self.storage.addToFavourite(post: post) { [weak self] error in
            
            if let error = error {
                self?.view?.showError(error: error)
                return
            }
            
            if let index = self?.posts.firstIndex(where: { $0.id == post.id }) {
                let i = Int(index)
                let indexPath = IndexPath(row: i, section: 0)
                self?.view?.updateViewFavourite(indexPath: indexPath)
            }
            
        }
    }
    
    func removeFromFavourite(post: IPost) {
        
        self.storage.removeFromFavourite(post: post) { [weak self] error in
            
            if let error = error {
                self?.view?.showError(error: error)
                return
            }
            
            if let index = self?.posts.firstIndex(where: { $0.id == post.id }) {
                let i = Int(index)
                let indexPath = IndexPath(row: i, section: 0)
                self?.view?.updateViewFavourite(indexPath: indexPath)
            }
            
        }
        
    }
    
    func isFavourite(post: IPost) -> Bool {
        
        self.storage.isFavourite(post: post)
        
    }
    
}
