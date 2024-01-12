//
//  Storage.swift
//  IosSolid
//
//  Created by Grigory Sapogov on 23.12.2023.
//

import Foundation

protocol IStorage: AnyObject {
    
    static var shared: IStorage { get }
    
    func saveToStorage(array: [[String: Any]], completion: @escaping (Error?) -> Void)
    
    func fetchFromStorage(completion: @escaping (Swift.Result<[IVacancy], Error>) -> Void)
    
    func fetchFavourites(completion: @escaping (Swift.Result<[IVacancy], Error>) -> Void)
    
    func addToFavourite(vacancy: IVacancy, completion: @escaping (Error?) -> Void)
    
    func removeFromFavourite(vacancy: IVacancy, completion: @escaping (Error?) -> Void)
    
    func isFavourite(vacancy: IVacancy) -> Bool
    
}
