//
//  FavouritePostListPresenter.swift
//  iosArchitecture
//
//  Created by Grigory Sapogov on 08.01.2024.
//

import Foundation

protocol IFavouritePostListPresenter: AnyObject {
    
    var view: IFavouritePostListViewController? { get set }
    
    var posts: [IPost] { get }
    
    func fetchFavourites()
    
}

final class FavouritePostListPresenter: IFavouritePostListPresenter {
    
    weak var view: IFavouritePostListViewController?
    
    private(set) var posts: [IPost] = []
    
    private let storage: IStorage
    
    init(storage: IStorage = UserDefaultStorage()) {
        self.storage = storage
    }
    
    func fetchFavourites() {
        
        self.storage.fetchFavourites { [weak self] result in
            
            switch result {
            case let .failure(error):
                DispatchQueue.main.async {
                    self?.view?.showError(error: error)
                }
            case let .success(posts):
                self?.posts = posts
                DispatchQueue.main.async {
                    self?.view?.updateView()
                }
            }
            
        }
        
    }
    
}
