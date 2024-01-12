//
//  VacancyListPresenter.swift
//  IosSolid
//
//  Created by Grigory Sapogov on 23.12.2023.
//

import Foundation

protocol IVacancyListPresenter: AnyObject {

    var view: IVacancyListViewController? { get set }
    
    var vacancies: [IVacancy] { get }
    
    func update()
    
    func fetchFromStorage()
    
    func addToFavourite(vacancy: IVacancy)
    
    func removeFromFavourite(vacancy: IVacancy)
    
    func isFavourite(vacancy: IVacancy) -> Bool
    
}

final class VacancyListPresenter: IVacancyListPresenter {
    
    weak var view: IVacancyListViewController?
    
    private(set) var vacancies: [IVacancy] = []
    
    private let api: IApi
    
    private let storage: IStorage
    
    init(api: IApi = Api(),
         storage: IStorage = VacancyStorage.shared) {
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
            case let .success(vacancies):
                self?.vacancies = vacancies
                self?.view?.updateView()
            }
            
        }
        
    }
    
    func addToFavourite(vacancy: IVacancy) {
        
        self.storage.addToFavourite(vacancy: vacancy) { [weak self] error in
            
            if let error = error {
                self?.view?.showError(error: error)
                return
            }
            
            if let index = self?.vacancies.firstIndex(where: { $0.id == vacancy.id }) {
                let i = Int(index)
                let indexPath = IndexPath(row: i, section: 0)
                self?.view?.updateViewFavourite(indexPath: indexPath)
            }
            
        }
    }
    
    func removeFromFavourite(vacancy: IVacancy) {
        
        self.storage.removeFromFavourite(vacancy: vacancy) { [weak self] error in
            
            if let error = error {
                self?.view?.showError(error: error)
                return
            }
            
            if let index = self?.vacancies.firstIndex(where: { $0.id == vacancy.id }) {
                let i = Int(index)
                let indexPath = IndexPath(row: i, section: 0)
                self?.view?.updateViewFavourite(indexPath: indexPath)
            }
            
        }
        
    }
    
    func isFavourite(vacancy: IVacancy) -> Bool {
        
        self.storage.isFavourite(vacancy: vacancy)
        
    }
    
}
