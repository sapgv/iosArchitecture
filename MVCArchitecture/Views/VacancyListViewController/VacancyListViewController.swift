//
//  VacancyListViewController.swift
//  MVCArchitecture
//
//  Created by Grigory Sapogov on 12.01.2024.
//

import UIKit

final class VacancyListViewController: UIViewController {

    private var vacancies: [IVacancy] = []
    
    private var tableView: UITableView!
    
    var storage: IStorage!
    
    var api: IApi!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Vacancy"
        self.view.backgroundColor = .systemBackground
        self.setupTableView()
        self.layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchFromStorage()
    }

    private func setupTableView() {
        
        self.tableView = UITableView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.register(UINib(nibName: "VacancyCell", bundle: nil), forCellReuseIdentifier: "VacancyCell")
        
    }
    
    private func layout() {
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableView)
        
        self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    private func endRefreshing() {
        self.tableView.refreshControl?.endRefreshing()
    }
    
}

//MARK: - Update

extension VacancyListViewController {
    
    private func fetchFromStorage() {
        
        self.storage.fetchFromStorage { [weak self] result in
            
            switch result {
            case let .failure(error):
                DispatchQueue.main.async {
                    self?.showError(error: error)
                }
            case let .success(vacancies):
                self?.vacancies = vacancies
                DispatchQueue.main.async {
                    self?.updateView()
                }
            }
            
        }
        
    }
    
    @objc
    private func refresh() {
        
        self.update()
        
    }
    
    private func update() {
        
        self.api.fetchApiData { [weak self] result in
            
            switch result {
            case let .failure(error):
                
                DispatchQueue.main.async {
                    self?.showError(error: error)
                }
                
            case let .success(array):
                
                self?.storage.saveToStorage(array: array) { error in
                    
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.showError(error: error)
                        }
                        return
                    }

                    self?.fetchFromStorage()
                    
                }
                
            }
            
        }
        
    }
    
}

extension VacancyListViewController {
    
    private func updateView() {
        
        self.endRefreshing()
        self.tableView.reloadData()
        
    }
    
    private func updateViewFavourite(indexPath: IndexPath) {
        
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    private func showError(error: Error) {
        
        print(error)
        
    }
    
    private func showPost(vacancy: IVacancy) {
        
        let viewController = VacancyDetailViewController()
        viewController.vacancy = vacancy
        viewController.storage = VacancyStorage.shared

        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

//MARK: - Favourites

extension VacancyListViewController {
    
    private func isFavourite(vacancy: IVacancy) -> Bool {
        
        self.storage.isFavourite(vacancy: vacancy)
        
    }
    
    private func addToFavourite(vacancy: IVacancy) {
        
        self.storage.addToFavourite(vacancy: vacancy) { [weak self] error in
            
            if let error = error {
                self?.showError(error: error)
                return
            }
            
            if let index = self?.vacancies.firstIndex(where: { $0.id == vacancy.id }) {
                let i = Int(index)
                let indexPath = IndexPath(row: i, section: 0)
                self?.updateViewFavourite(indexPath: indexPath)
            }
            
        }
    }
    
    private func removeFromFavourite(vacancy: IVacancy) {
        
        self.storage.removeFromFavourite(vacancy: vacancy) { [weak self] error in
            
            if let error = error {
                self?.showError(error: error)
                return
            }
            
            if let index = self?.vacancies.firstIndex(where: { $0.id == vacancy.id }) {
                let i = Int(index)
                let indexPath = IndexPath(row: i, section: 0)
                self?.updateViewFavourite(indexPath: indexPath)
            }
            
        }
        
    }
    
}

extension VacancyListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.vacancies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VacancyCell", for: indexPath) as? VacancyCell else { return UITableViewCell() }
        
        let vacancy = self.vacancies[indexPath.row]
        
        let isFavourite = self.isFavourite(vacancy: vacancy)
        
        cell.setup(vacancy: vacancy)
        cell.setup(isFavourite: isFavourite)
        
        return cell
        
    }

}

extension VacancyListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vacancy = self.vacancies[indexPath.row]
        
        self.showPost(vacancy: vacancy)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let vacancy = self.vacancies[indexPath.row]
        
        let favouriteTrailingAction = FavouriteTrailingAction()
        
        let action = favouriteTrailingAction.trailingAction(vacancy: vacancy) { [weak self] in
            self?.addToFavourite(vacancy: vacancy)
        } remove: { [weak self] in
            self?.removeFromFavourite(vacancy: vacancy)
        }

        let config = UISwipeActionsConfiguration(actions: [action])
        
        return config

    }
    
}
