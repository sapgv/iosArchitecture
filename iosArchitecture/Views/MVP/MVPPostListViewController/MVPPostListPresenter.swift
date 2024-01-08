//
//  MVPPostListPresenter.swift
//  IosSolid
//
//  Created by Grigory Sapogov on 23.12.2023.
//

import Foundation

protocol IMVPPostListPresenter: AnyObject {

    var view: IMVPPostListViewController? { get set }
    
    var posts: [IPost] { get }
    
    func update()
    
    func fetchFromStorage()
    
}

final class MVPPostListPresenter: IMVPPostListPresenter {
    
    weak var view: IMVPPostListViewController?
    
    private(set) var posts: [IPost] = []
    
    private let api: IApi
    
    private let storage: IStorage
    
    init(api: IApi = Api(),
         storage: IStorage = UserDefaultStorage()) {
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
