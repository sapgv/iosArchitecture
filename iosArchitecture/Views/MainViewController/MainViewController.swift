//
//  MainViewController.swift
//  iosArchitecture
//
//  Created by Grigory Sapogov on 31.12.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let stackView: VerticalStackView = VerticalStackView()
    
    private var buttonMVC: MainButton = MainButton()
    
    private var buttonMVVM: MainButton = MainButton()
    
    private var buttonMVP: MainButton = MainButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Main"
        self.view.backgroundColor = .systemBackground
        self.setupButtons()
        self.layout()
    }
    
    private func setupButtons() {
        
        buttonMVC.setTitle("MVC", for: .normal)
        buttonMVC.actionCompletion = { [weak self] in
            
            
        }
        
        buttonMVVM.setTitle("MVVM", for: .normal)
        buttonMVVM.actionCompletion = { [weak self] in
            
            
        }
        
        buttonMVP.setTitle("MVP", for: .normal)
        buttonMVP.actionCompletion = { [weak self] in
            
            self?.showPostListViewController()
            
        }
        
    }
    
    private func layout() {
        
        self.view.addSubview(stackView)
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
        self.stackView.addArrangedSubview(self.buttonMVC)
        self.stackView.addArrangedSubview(self.buttonMVVM)
        self.stackView.addArrangedSubview(self.buttonMVP)
        
        self.buttonMVC.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.buttonMVVM.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.buttonMVP.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    
    private func showPostListViewController() {
        
        let storage = UserDefaultStorage()
        let presenter = PostListViewPresenter(storage: storage)
        let viewController = PostListViewController()
        viewController.presenter = presenter
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}
