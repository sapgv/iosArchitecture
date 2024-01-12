//
//  FavouriteVacancyListViewModel.swift
//  MVVMArchitecture
//
//  Created by Grigory Sapogov on 12.01.2024.
//

import Foundation

protocol IFavouriteVacancyListViewModel: AnyObject {
    
    var vacancies: [IVacancy] { get }
    
    var favouritesNeedUpdate: Bool { get }
    
    var updateViewCompletion: ((Error?) -> Void)? { get set }
    
    func fetchFavourites()
    
    func removeFromFavourite(vacancy: IVacancy)
    
}

final class FavouriteVacancyListViewModel: IFavouriteVacancyListViewModel {
    
    var updateViewCompletion: ((Error?) -> Void)?
    
    private(set) var vacancies: [IVacancy] = []
    
    private(set) var favouritesNeedUpdate: Bool = false
    
    private let storage: IStorage
    
    init(storage: IStorage = VacancyStorage.shared) {
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
                self?.updateViewCompletion?(error)
            case let .success(vacancies):
                self?.vacancies = vacancies
                self?.updateViewCompletion?(nil)
            }
            
        }
        
    }
    
    func removeFromFavourite(vacancy: IVacancy) {
        
        self.storage.removeFromFavourite(vacancy: vacancy) { [weak self] error in
            
            if let error = error {
                self?.updateViewCompletion?(error)
                return
            }
            
            self?.vacancies.removeAll(where: { $0.id == vacancy.id })
            self?.updateViewCompletion?(nil)
            
        }
        
    }
    
    //MARK: - Private
    
    @objc
    private func favouritesDidChange() {
        self.favouritesNeedUpdate = true
    }
    
}
