//
//  VacancyDetailViewController.swift
//  iosArchitecture
//
//  Created by Grigory Sapogov on 07.01.2024.
//

import UIKit

protocol IVacancyDetailViewController: UIViewController {
    
    func updateView()
    
    func showError(error: Error)
    
}

final class VacancyDetailViewController: UIViewController {
    
    var presenter: IVacancyDetailViewPresenter!
    
    private let titleLabel: DetailTitleLabel = DetailTitleLabel()
    
    private let textLabel: DetailTextLabel = DetailTextLabel()
    
    private let favouriteButton: FavouriteButton = FavouriteButton()
    
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Vacancy"
        self.view.backgroundColor = .systemBackground
        self.presenter.view = self
        self.setupStackView()
        self.setupButton()
        self.layout()
        self.setupView()
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
            self?.presenter.addToFavourite()
        }
        
        self.favouriteButton.remove = { [weak self] in
            self?.presenter.removeFromFavourite()
        }
        
    }
    
    private func setupView() {
        self.titleLabel.text = self.presenter.vacancy.title
        self.textLabel.text = self.presenter.vacancy.body
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

extension VacancyDetailViewController: IVacancyDetailViewController {
    
    func updateView() {
        
        self.favouriteButton.isFavourite = self.presenter.isFavourite
        
    }
    
    func showError(error: Error) {
        
        print(error)
        
    }
    
}
