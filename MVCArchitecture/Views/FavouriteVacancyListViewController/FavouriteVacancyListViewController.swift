//
//  FavouriteVacancyListViewController.swift
//  MVCArchitecture
//
//  Created by Grigory Sapogov on 12.01.2024.
//

import UIKit

final class FavouriteVacancyListViewController: UIViewController {
    
    private var vacancies: [IVacancy] = []
    
    private var favouritesNeedUpdate: Bool = false
    
    private var tableView: UITableView!
    
    var storage: IStorage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favourite"
        self.view.backgroundColor = .systemBackground
        self.setupTableView()
        self.fetchFavourites()
        self.layout()
        NotificationCenter.default.addObserver(self, selector: #selector(favouritesDidChange), name: .favouritesDidChange, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.favouritesNeedUpdate {
            self.update()
        }
    }
    
    private func setupTableView() {
        
        self.tableView = UITableView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.register(UINib(nibName: "VacancyCell", bundle: nil), forCellReuseIdentifier: "VacancyCell")
        
    }
    
    @objc
    private func refresh() {
        
        self.update()
        
    }
    
    private func update() {
        
        self.fetchFavourites()
        
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
    
    private func showPost(vacancy: IVacancy) {
        
        let viewController = VacancyDetailViewController()
        viewController.vacancy = vacancy
        viewController.storage = VacancyStorage.shared

        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

extension FavouriteVacancyListViewController {
    
    func updateView() {
        
        self.endRefreshing()
        self.tableView.reloadData()
        
    }
    
    func showError(error: Error) {
        
        print(error)
        
    }
    
}

//MARK: - Favourites

extension FavouriteVacancyListViewController {
    
    private func fetchFavourites() {
        
        self.storage.fetchFavourites { [weak self] result in
            
            defer {
                self?.favouritesNeedUpdate = false
            }
            
            switch result {
            case let .failure(error):
                self?.showError(error: error)
            case let .success(vacancies):
                self?.vacancies = vacancies
                self?.updateView()
            }
            
        }
        
    }
    
    private func removeFromFavourite(vacancy: IVacancy) {
        
        self.storage.removeFromFavourite(vacancy: vacancy) { [weak self] error in
            
            if let error = error {
                self?.showError(error: error)
                return
            }
            
            self?.vacancies.removeAll(where: { $0.id == vacancy.id })
            self?.updateView()
            
        }
        
    }
    
    @objc
    private func favouritesDidChange() {
        self.favouritesNeedUpdate = true
    }
    
}

extension FavouriteVacancyListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.vacancies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VacancyCell", for: indexPath) as? VacancyCell else { return UITableViewCell() }
        
        let vacancy = self.vacancies[indexPath.row]
        
        cell.setup(vacancy: vacancy)
        
        return cell
        
    }

}

extension FavouriteVacancyListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vacancy = self.vacancies[indexPath.row]
        
        self.showPost(vacancy: vacancy)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let vacancy = self.vacancies[indexPath.row]
        
        let favouriteTrailingAction = FavouriteTrailingAction()
        
        let action = favouriteTrailingAction.trailingAction(vacancy: vacancy, add: nil, remove: { [weak self] in
            self?.removeFromFavourite(vacancy: vacancy)
        })
        
        let config = UISwipeActionsConfiguration(actions: [action])
        
        return config
        
    }
    
}
