//
//  Vacancy.swift
//  IosSolid
//
//  Created by Grigory Sapogov on 23.12.2023.
//

import Foundation

protocol IVacancy: Codable {
    
    var id: Int { get }
    
    var title: String { get }
    
    var body: String { get }
    
    var solary: String { get }
    
    init(data: [String: Any])
    
}

final class Vacancy: IVacancy, Codable, Hashable {
    
    static func == (lhs: Vacancy, rhs: Vacancy) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    
    let title: String
    
    let body: String
    
    var solary: String
    
    init(id: Int, title: String, body: String, solary: String) {
        self.id = id
        self.title = title
        self.body = body
        self.solary = solary
    }
    
    init(data: [String: Any]) {
        self.id = data["id"] as? Int ?? 0
        self.title = data["title"] as? String ?? ""
        self.body = data["body"] as? String ?? ""
        self.solary = data["solary"] as? String ?? ""
    }
    
}

