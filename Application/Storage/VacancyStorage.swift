//
//  VacancyStorage.swift
//  IosSolid
//
//  Created by Grigory Sapogov on 23.12.2023.
//

import Foundation

final class VacancyStorage: IStorage {
    
    private let arrayKey = "vacancies"

    private let favouriteKey = "favourite"
    
    private var favouritesIds: [Int] = []
    
    static let shared: IStorage = VacancyStorage()
    
    private init() {
        self.updateFavouritesIds()
    }
    
    private var favouritesSet: Set<Vacancy> {
        return Set<Vacancy>(self.favourites)
    }
    
    private var favourites: [Vacancy] {
        get {
            guard let data = UserDefaults.standard.object(forKey: self.favouriteKey) as? Data else { return [] }
            let decoder = JSONDecoder()
            let vacancies = try? decoder.decode([Vacancy].self, from: data)
            return vacancies ?? []
        }
        set {
            let encoder = JSONEncoder()
            let encoded = try? encoder.encode(newValue)
            UserDefaults.standard.set(encoded, forKey: self.favouriteKey)
            UserDefaults.standard.synchronize()
            self.updateFavouritesCompletion()
        }
    }
    
    func saveToStorage(array: [[String: Any]], completion: @escaping (Error?) -> Void) {
        
        DispatchQueue.global().async {
            
            do {
                
                let vacancies = array.map { Vacancy(data: $0) }
                
                let encoder = JSONEncoder()
                
                let encoded = try encoder.encode(vacancies)
                
                UserDefaults.standard.set(encoded, forKey: self.arrayKey)
                UserDefaults.standard.synchronize()
                
                DispatchQueue.main.async {
                    completion(nil)
                }
                
            }
            catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
            
        }
        
    }
    
    
    func fetchFromStorage(completion: @escaping (Swift.Result<[IVacancy], Error>) -> Void) {
        
        DispatchQueue.global().async {
            
            do {
                
                guard let data = UserDefaults.standard.object(forKey: self.arrayKey) as? Data else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                
                let decoder = JSONDecoder()
                
                let vacancies = try decoder.decode([Vacancy].self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(vacancies))
                }
                
            }
            catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }
        
    }
    
    func fetchFavourites(completion: @escaping (Swift.Result<[IVacancy], Error>) -> Void) {
        
        DispatchQueue.global().async {
            
            let favourites = self.favouritesSet
            
            let array = Array(favourites)
            
            DispatchQueue.main.async {
                completion(.success(array))
            }
            
        }
        
    }
    
    func addToFavourite(vacancy: IVacancy, completion: @escaping (Error?) -> Void) {
        
        DispatchQueue.global().async {
            
            if let vacancy = vacancy as? Vacancy, !self.favourites.contains(vacancy) {
                self.favourites.append(vacancy)
            }

            DispatchQueue.main.async {
                completion(nil)
            }
            
        }
        
    }
    
    func removeFromFavourite(vacancy: IVacancy, completion: @escaping (Error?) -> Void) {
        
        DispatchQueue.global().async {
            
            if let vacancy = vacancy as? Vacancy {
                self.favourites.removeAll(where: { $0.id == vacancy.id })
            }

            DispatchQueue.main.async {
                completion(nil)
            }
            
        }
        
    }
    
    func isFavourite(vacancy: IVacancy) -> Bool {
        
        self.favouritesIds.contains(vacancy.id)
        
    }
    
    private func updateFavouritesIds() {
        self.favouritesIds = self.favouritesSet.map { $0.id }
    }
    
//    @objc
//    private func favouritesDidChange() {
//        self.updateFavouritesIds()
//    }
    
    private func updateFavouritesCompletion() {
        self.updateFavouritesIds()
        NotificationCenter.default.post(name: .favouritesDidChange, object: nil)
    }
    
}
