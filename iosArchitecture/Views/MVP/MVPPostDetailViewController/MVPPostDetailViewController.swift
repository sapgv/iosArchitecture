//
//  MVPPostDetailViewController.swift
//  iosArchitecture
//
//  Created by Grigory Sapogov on 07.01.2024.
//

import UIKit

protocol IMVPPostDetailViewController: UIViewController {
    
    func updateView()
    
    func showError(error: Error)
    
}

final class MVPPostDetailViewController: UIViewController {
    
    var presenter: IPostDetailViewPresenter!
    
    private let titleLabel: DetailTitleLabel = DetailTitleLabel()
    
    private let textLabel: DetailTextLabel = DetailTextLabel()
    
    private let addFavouriteButton: AddFavouriteButton = AddFavouriteButton()
    
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Post"
        self.view.backgroundColor = .systemBackground
        self.presenter.view = self
        self.setupStackView()
        self.setupButton()
        self.layout()
        self.setupView()
    }
    
    private func setupStackView() {
        
        self.stackView.axis = .vertical
        self.stackView.distribution = .fill
        self.stackView.alignment = .fill
        self.stackView.spacing = 8
        
    }
    
    private func setupButton() {
            
        self.addFavouriteButton.completion = { [weak self] in
            
            self?.presenter.addToFavourite()
            
        }
        
    }
    
    private func setupView() {
        self.titleLabel.text = self.presenter.post.title
        self.textLabel.text = self.presenter.post.body
    }
    
    private func layout() {
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addFavouriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.textLabel)
        self.stackView.addArrangedSubview(self.addFavouriteButton)
        
        self.stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
        self.addFavouriteButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    
}

extension MVPPostDetailViewController: IMVPPostDetailViewController {
    
    func updateView() {
        
//        self.endRefreshing()
//        self.tableView.reloadData()
        
    }
    
    func showError(error: Error) {
        
        print(error)
        
    }
    
}
