//
//  VerticalStackView.swift
//  iosArchitecture
//
//  Created by Grigory Sapogov on 31.12.2023.
//

import UIKit

final class VerticalStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
            
        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .fill
        self.spacing = 8
        
    }
    
}
