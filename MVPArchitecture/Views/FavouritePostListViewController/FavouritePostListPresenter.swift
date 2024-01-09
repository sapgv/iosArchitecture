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
    
    var favouritesNeedUpdate: Bool { get }
    
    func fetchFavourites()
    
}

final class FavouritePostListPresenter: IFavouritePostListPresenter {
    
    weak var view: IFavouritePostListViewController?
    
    private(set) var posts: [IPost] = []
    
    private(set) var favouritesNeedUpdate: Bool = false
    
    private let storage: IStorage
    
    init(storage: IStorage = PostStorage()) {
        self.storage = storage
        NotificationCenter.default.addObserver(self, selector: #selector(favouritesDidChange), name: .favouritesDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func fetchFavourites() {
        
        self.storage.fetchFavourites { [weak self] result in
            
            defer {
                self?.favouritesNeedUpdate = false
            }
            
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
    
    @objc
    private func favouritesDidChange() {
        self.favouritesNeedUpdate = true
    }
    
}
