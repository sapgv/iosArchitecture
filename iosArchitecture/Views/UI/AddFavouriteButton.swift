//
//  AddFavouriteButton.swift
//  iosArchitecture
//
//  Created by Grigory Sapogov on 08.01.2024.
//

import UIKit

final class AddFavouriteButton: UIButton {
    
    var completion: (() -> Void)?
    
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
        self.backgroundColor = .systemBlue
        self.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        self.setTitle("Add to favourite", for: .normal)
        self.addTarget(self, action: #selector(actionAddFovourite), for: .touchUpInside)
    }
    
    @objc
    private func actionAddFovourite() {
        self.completion?()
    }
    
}
