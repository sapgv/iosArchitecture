//
//  PostDetailViewPresenter.swift
//  iosArchitecture
//
//  Created by Grigory Sapogov on 07.01.2024.
//

import Foundation

protocol IPostDetailViewPresenter: AnyObject {
    
    var view: IPostDetailViewController? { get set }
    
    var post: IPost { get }
    
    var isFavourite: Bool { get }
    
    var favouritesNeedUpdate: Bool { get }
    
    func addToFavourite()
    
    func removeFromFavourite()
    
}

final class PostDetailViewPresenter: IPostDetailViewPresenter {
    
    let post: IPost
    
    var isFavourite: Bool {
        self.storage.isFavourite(post: self.post)
    }
    
    private(set) var favouritesNeedUpdate: Bool = false
    
    weak var view: IPostDetailViewController?
    
    private let storage: IStorage
    
    init(post: IPost,
         storage: IStorage = PostStorage()) {
        self.post = post
        self.storage = storage
        NotificationCenter.default.addObserver(self, selector: #selector(favouritesDidChange), name: .favouritesDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addToFavourite() {
        
        self.storage.addToFavourite(post: self.post) { [weak self] error in
            
            if let error = error {
                self?.view?.showError(error: error)
                return
            }
            
            self?.view?.updateView()
            
        }
        
    }
    
    func removeFromFavourite() {
        
        self.storage.removeFromFavourite(post: self.post) { [weak self] error in
            
            if let error = error {
                self?.view?.showError(error: error)
                return
            }
            
            self?.view?.updateView()
            
        }
        
    }
    
    @objc
    private func favouritesDidChange() {
        self.favouritesNeedUpdate = true
    }
    
}
