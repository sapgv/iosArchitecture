//
//  Storage.swift
//  IosSolid
//
//  Created by Grigory Sapogov on 23.12.2023.
//

import Foundation

protocol IStorage: AnyObject {
    
    func saveToStorage(array: [[String: Any]], completion: @escaping (Error?) -> Void)
    
    func fetchFromStorage(completion: @escaping (Swift.Result<[IPost], Error>) -> Void)
    
    func fetchFavourites(completion: @escaping (Swift.Result<[IPost], Error>) -> Void)
    
    func addToFavourite(post: IPost, completion: @escaping (Error?) -> Void)
    
    func removeFromFavourite(post: IPost, completion: @escaping (Error?) -> Void)
    
    func isFavourite(post: IPost) -> Bool
    
}
