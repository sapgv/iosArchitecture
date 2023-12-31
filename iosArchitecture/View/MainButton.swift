//
//  MainButton.swift
//  iosArchitecture
//
//  Created by Grigory Sapogov on 31.12.2023.
//

import UIKit

final class MainButton: UIButton {
    
    var actionCompletion: (() -> Void)?
    
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
        self.setTitleColor(.white, for: .normal)
        
        self.addTarget(self, action: #selector(actionTap), for: .touchUpInside)
        
    }
    
    @objc
    private func actionTap() {
        self.actionCompletion?()
    }
    
}

