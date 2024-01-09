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
    
    func addToFavourite()
    
}

final class PostDetailViewPresenter: IPostDetailViewPresenter {
    
    let post: IPost
    
    weak var view: IPostDetailViewController?
    
    private let storage: IStorage
    
    init(post: IPost,
         storage: IStorage = UserDefaultStorage()) {
        self.post = post
        self.storage = storage
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
    
}
