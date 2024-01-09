//
//  FavouriteImageView.swift
//  MVPArchitecture
//
//  Created by Grigory Sapogov on 09.01.2024.
//

import UIKit

final class FavouriteImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commontInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commontInit()
    }
    
    private func commontInit() {
        self.image = UIImage(systemName: "heart.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    }
    
}

