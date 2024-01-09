//
//  DetailTextLabel.swift
//  iosArchitecture
//
//  Created by Grigory Sapogov on 08.01.2024.
//

import UIKit

final class DetailTextLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
    }
    
}
