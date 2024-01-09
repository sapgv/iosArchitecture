//
//  Post.swift
//  IosSolid
//
//  Created by Grigory Sapogov on 23.12.2023.
//

import Foundation

protocol IPost: Codable {
    
    var id: Int { get }
    
    var title: String { get }
    
    var body: String { get }
    
    init(data: [String: Any])
    
}

final class Post: IPost, Codable, Hashable {
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    
    let title: String
    
    let body: String
    
    init(id: Int, title: String, body: String) {
        self.id = id
        self.title = title
        self.body = body
    }
    
    required init(data: [String: Any]) {
        self.id = data["id"] as? Int ?? 0
        self.title = data["title"] as? String ?? ""
        self.body = data["body"] as? String ?? ""
    }
    
}

