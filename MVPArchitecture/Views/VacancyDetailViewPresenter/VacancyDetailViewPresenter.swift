//
//  VacancyDetailViewPresenter.swift
//  iosArchitecture
//
//  Created by Grigory Sapogov on 07.01.2024.
//

import Foundation

protocol IVacancyDetailViewPresenter: AnyObject {
    
    var view: IVacancyDetailViewController? { get set }
    
    var vacancy: IVacancy { get }
    
    var isFavourite: Bool { get }
    
    var favouritesNeedUpdate: Bool { get }
    
    func addToFavourite()
    
    func removeFromFavourite()
    
}

final class VacancyDetailViewPresenter: IVacancyDetailViewPresenter {
    
    let vacancy: IVacancy
    
    var isFavourite: Bool {
        self.storage.isFavourite(vacancy: self.vacancy)
    }
    
    private(set) var favouritesNeedUpdate: Bool = false
    
    weak var view: IVacancyDetailViewController?
    
    private let storage: IStorage
    
    init(vacancy: IVacancy,
         storage: IStorage = VacancyStorage.shared) {
        self.vacancy = vacancy
        self.storage = storage
    }
    
    func addToFavourite() {
        
        self.storage.addToFavourite(vacancy: self.vacancy) { [weak self] error in
            
            if let error = error {
                self?.view?.showError(error: error)
                return
            }
            
            self?.view?.updateView()
            
        }
        
    }
    
    func removeFromFavourite() {
        
        self.storage.removeFromFavourite(vacancy: self.vacancy) { [weak self] error in
            
            if let error = error {
                self?.view?.showError(error: error)
                return
            }
            
            self?.view?.updateView()
            
        }
        
    }
    
}
