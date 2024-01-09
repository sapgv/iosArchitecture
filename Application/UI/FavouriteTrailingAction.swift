//
//  FavouriteTrailingAction.swift
//  MVPArchitecture
//
//  Created by Grigory Sapogov on 09.01.2024.
//

import UIKit

protocol IFavouriteTrailingAction: AnyObject {
    
    func trailingAction(post: IPost, add: (() -> Void)?, remove: (() -> Void)?) -> UIContextualAction
    
}

final class FavouriteTrailingAction: IFavouriteTrailingAction {
    
    private let storage: IStorage
    
    init(storage: IStorage = PostStorage()) {
        self.storage = storage
    }
    
    func trailingAction(post: IPost, add: (() -> Void)?, remove: (() -> Void)?) -> UIContextualAction {
        
        let isFavourite = self.storage.isFavourite(post: post)
        
        let style = isFavourite ? UIContextualAction.Style.destructive : .normal
        
        let backgroundColor: UIColor = isFavourite ? .systemRed : .systemGreen
        
        let text = isFavourite ? "Remove" : "Add"
        
        let handler = isFavourite ? remove : add
        
        let action = UIContextualAction(style: style, title: text, handler: { action, view, completion in
            
            handler?()
            
            completion(true)
            
        })
        
        action.backgroundColor = backgroundColor
        
        return action
        
    }
    
}
