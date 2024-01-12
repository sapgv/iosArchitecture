//
//  FavouriteVacancyListPresenter.swift
//  iosArchitecture
//
//  Created by Grigory Sapogov on 08.01.2024.
//

import Foundation

protocol IFavouriteVacancyListPresenter: AnyObject {
    
    var view: IFavouriteVacancyListViewController? { get set }
    
    var vacancies: [IVacancy] { get }
    
    var favouritesNeedUpdate: Bool { get }
    
    func fetchFavourites()
    
    func removeFromFavourite(vacancy: IVacancy)
    
}

final class FavouriteVacancyListPresenter: IFavouriteVacancyListPresenter {
    
    weak var view: IFavouriteVacancyListViewController?
    
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
                self?.view?.showError(error: error)
            case let .success(vacancies):
                self?.vacancies = vacancies
                self?.view?.updateView()
            }
            
        }
        
    }
    
    func removeFromFavourite(vacancy: IVacancy) {
        
        self.storage.removeFromFavourite(vacancy: vacancy) { [weak self] error in
            
            if let error = error {
                self?.view?.showError(error: error)
                return
            }
            
            self?.vacancies.removeAll(where: { $0.id == vacancy.id })
            self?.view?.updateView()
            
        }
        
    }
    
    //MARK: - Private
    
    @objc
    private func favouritesDidChange() {
        self.favouritesNeedUpdate = true
    }
    
}
