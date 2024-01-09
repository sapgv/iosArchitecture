//
//  FavouriteButton.swift
//  iosArchitecture
//
//  Created by Grigory Sapogov on 08.01.2024.
//

import UIKit

final class FavouriteButton: UIButton {
    
    var add: (() -> Void)?
    
    var remove: (() -> Void)?
    
    var isFavourite: Bool? {
        didSet {
            self.update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.layer.cornerRadius = 8
        let image = UIImage(systemName: "heart.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        self.setImage(image, for: .normal)
        self.setImage(image, for: .focused)
        self.setImage(image, for: .highlighted)
        self.addTarget(self, action: #selector(actionTap), for: .touchUpInside)
    }
    
    @objc
    private func actionTap() {

        guard let isFavourite = self.isFavourite else { return }
        
        switch isFavourite {
        case true:
            self.remove?()
        case false:
            self.add?()
        }

    }
    
    func update() {
        
        guard let isFavourite = self.isFavourite else { return }
        
        switch isFavourite {
        case true:
            self.setTitle("Remove from favourite", for: .normal)
            self.backgroundColor = .systemRed
        case false:
            self.setTitle("Add to favourite", for: .normal)
            self.backgroundColor = .systemGreen
        }
        
    }
    
}
