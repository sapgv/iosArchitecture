//
//  VacancyListViewModel.swift
//  MVVMArchitecture
//
//  Created by Grigory Sapogov on 12.01.2024.
//

import Foundation

protocol IVacancyListModel: AnyObject {

    var vacancies: [IVacancy] { get }
    
    var updateViewCompletion: ((Error?) -> Void)? { get set }
    
    var updateViewFavourite: ((IndexPath) -> Void)? { get set }
    
    func update()
    
    func fetchFromStorage()
    
    func addToFavourite(vacancy: IVacancy)
    
    func removeFromFavourite(vacancy: IVacancy)
    
    func isFavourite(vacancy: IVacancy) -> Bool
    
}

final class VacancyListModel: IVacancyListModel {
    
    var updateViewCompletion: ((Error?) -> Void)?
    
    var updateViewFavourite: ((IndexPath) -> Void)?
    
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
                    self?.updateViewCompletion?(error)
                }
                
            case let .success(array):
                
                self?.storage.saveToStorage(array: array) { error in
                    
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.updateViewCompletion?(error)
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
                self?.updateViewCompletion?(error)
            case let .success(vacancies):
                self?.vacancies = vacancies
                self?.updateViewCompletion?(nil)
            }
            
        }
        
    }
    
    func addToFavourite(vacancy: IVacancy) {
        
        self.storage.addToFavourite(vacancy: vacancy) { [weak self] error in
            
            if let error = error {
                self?.updateViewCompletion?(error)
                return
            }
            
            if let index = self?.vacancies.firstIndex(where: { $0.id == vacancy.id }) {
                let i = Int(index)
                let indexPath = IndexPath(row: i, section: 0)
                self?.updateViewFavourite?(indexPath)
            }
            
        }
    }
    
    func removeFromFavourite(vacancy: IVacancy) {
        
        self.storage.removeFromFavourite(vacancy: vacancy) { [weak self] error in
            
            if let error = error {
                self?.updateViewCompletion?(error)
                return
            }
            
            if let index = self?.vacancies.firstIndex(where: { $0.id == vacancy.id }) {
                let i = Int(index)
                let indexPath = IndexPath(row: i, section: 0)
                self?.updateViewFavourite?(indexPath)
            }
            
        }
        
    }
    
    func isFavourite(vacancy: IVacancy) -> Bool {
        
        self.storage.isFavourite(vacancy: vacancy)
        
    }
    
}
