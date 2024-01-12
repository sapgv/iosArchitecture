//
//  FavouriteVacancyListViewController.swift
//  MVVMArchitecture
//
//  Created by Grigory Sapogov on 12.01.2024.
//

import UIKit

final class FavouriteVacancyListViewController: UIViewController {
    
    var viewModel: IFavouriteVacancyListViewModel!
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favourite"
        self.view.backgroundColor = .systemBackground
        self.setupTableView()
        self.setupViewModel()
        self.viewModel.fetchFavourites()
        self.layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.viewModel.favouritesNeedUpdate {
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
    
    private func setupViewModel() {
        
        self.viewModel.updateViewCompletion = { [weak self] error in
            
            if let error = error {
                print(error)
                return
            }
            
            self?.updateView()
            
        }
        
    }
    
    @objc
    private func refresh() {
        
        self.update()
        
    }
    
    private func update() {
        
        self.viewModel.fetchFavourites()
        
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
    
    private func showVacancy(vacancy: IVacancy) {
        
        let viewModel = VacancyDetailViewModel(vacancy: vacancy)
        let viewController = VacancyDetailViewController()
        viewController.viewModel = viewModel

        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

extension FavouriteVacancyListViewController {
    
    private func updateView() {
        
        self.endRefreshing()
        self.tableView.reloadData()
        
    }
    
    private func showError(error: Error) {
        
        print(error)
        
    }
    
}

extension FavouriteVacancyListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.vacancies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VacancyCell", for: indexPath) as? VacancyCell else { return UITableViewCell() }
        
        let vacancy = self.viewModel.vacancies[indexPath.row]
        
        cell.setup(vacancy: vacancy)
        
        return cell
        
    }

}

extension FavouriteVacancyListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vacancy = self.viewModel.vacancies[indexPath.row]
        
        self.showVacancy(vacancy: vacancy)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let vacancy = self.viewModel.vacancies[indexPath.row]
        
        let favouriteTrailingAction = FavouriteTrailingAction()
        
        let action = favouriteTrailingAction.trailingAction(vacancy: vacancy, add: nil, remove: { [weak self] in
            self?.viewModel.removeFromFavourite(vacancy: vacancy)
        })
        
        let config = UISwipeActionsConfiguration(actions: [action])
        
        return config
        
    }
    
}
