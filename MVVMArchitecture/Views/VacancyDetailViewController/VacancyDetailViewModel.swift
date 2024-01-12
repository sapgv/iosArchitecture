//
//  VacancyDetailViewModel.swift
//  MVVMArchitecture
//
//  Created by Grigory Sapogov on 12.01.2024.
//

import Foundation

protocol IVacancyDetailViewModel: AnyObject {
    
    var vacancy: IVacancy { get }
    
    var isFavourite: Bool { get }
    
    var favouritesNeedUpdate: Bool { get }
    
    var updateViewCompletion: ((Error?) -> Void)? { get set }
    
    func addToFavourite()
    
    func removeFromFavourite()
    
}

final class VacancyDetailViewModel: IVacancyDetailViewModel {
    
    let vacancy: IVacancy
    
    var isFavourite: Bool {
        self.storage.isFavourite(vacancy: self.vacancy)
    }
    
    var updateViewCompletion: ((Error?) -> Void)?
    
    private(set) var favouritesNeedUpdate: Bool = false
    
    private let storage: IStorage
    
    init(vacancy: IVacancy,
         storage: IStorage = VacancyStorage.shared) {
        self.vacancy = vacancy
        self.storage = storage
    }
    
    func addToFavourite() {
        
        self.storage.addToFavourite(vacancy: self.vacancy) { [weak self] error in
            
            if let error = error {
                self?.updateViewCompletion?(error)
                return
            }
            
            self?.updateViewCompletion?(nil)
            
        }
        
    }
    
    func removeFromFavourite() {
        
        self.storage.removeFromFavourite(vacancy: self.vacancy) { [weak self] error in
            
            if let error = error {
                self?.updateViewCompletion?(error)
                return
            }
            
            self?.updateViewCompletion?(nil)
            
        }
        
    }
    
}
