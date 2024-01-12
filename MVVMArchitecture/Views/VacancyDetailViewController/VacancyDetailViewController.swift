//
//  VacancyDetailViewController.swift
//  MVVMArchitecture
//
//  Created by Grigory Sapogov on 12.01.2024.
//

import UIKit

final class VacancyDetailViewController: UIViewController {
    
    var viewModel: IVacancyDetailViewModel!
    
    private let titleLabel: DetailTitleLabel = DetailTitleLabel()
    
    private let textLabel: DetailTextLabel = DetailTextLabel()
    
    private let favouriteButton: FavouriteButton = FavouriteButton()
    
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Vacancy"
        self.view.backgroundColor = .systemBackground
        self.setupStackView()
        self.setupButton()
        self.setupViewModel()
        self.setupView()
        self.layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateView()
    }
    
    private func setupStackView() {
        
        self.stackView.axis = .vertical
        self.stackView.distribution = .fill
        self.stackView.alignment = .fill
        self.stackView.spacing = 8
        
    }
    
    private func setupButton() {
            
        self.favouriteButton.add = { [weak self] in
            self?.viewModel.addToFavourite()
        }
        
        self.favouriteButton.remove = { [weak self] in
            self?.viewModel.removeFromFavourite()
        }
        
    }
    
    private func setupViewModel() {
        
        self.viewModel.updateViewCompletion = { [weak self] error in
            
            if let error = error {
                print(error)
                return
            }
            
            self?.updateView()
            
        }
        
    }
    
    private func setupView() {
        self.titleLabel.text = self.viewModel.vacancy.title
        self.textLabel.text = self.viewModel.vacancy.body
    }
    
    private func layout() {
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.textLabel)
        self.stackView.addArrangedSubview(self.favouriteButton)
        
        self.stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
        self.favouriteButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    
}

extension VacancyDetailViewController {
    
    private func updateView() {
        
        self.favouriteButton.isFavourite = self.viewModel.isFavourite
        
    }
    
    private func showError(error: Error) {
        
        print(error)
        
    }
    
}
