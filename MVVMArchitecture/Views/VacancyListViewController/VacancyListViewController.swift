//
//  VacancyListViewController.swift
//  MVVMArchitecture
//
//  Created by Grigory Sapogov on 12.01.2024.
//

import UIKit

final class VacancyListViewController: UIViewController {

    var viewModel: IVacancyListModel!
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Vacancy"
        self.view.backgroundColor = .systemBackground
        self.setupTableView()
        self.setupViewModel()
        self.layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.fetchFromStorage()
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
        
        self.viewModel.updateViewFavourite = { [weak self] indexPath in
            
            self?.updateViewFavourite(indexPath: indexPath)
        }
        
    }
    
    @objc
    private func refresh() {
        
        self.viewModel.update()
        
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
        
        let viewModel = VacancyDetailViewModel(vacancy: vacancy)
        let viewController = VacancyDetailViewController()
        viewController.viewModel = viewModel

        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

extension VacancyListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.vacancies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VacancyCell", for: indexPath) as? VacancyCell else { return UITableViewCell() }
        
        let vacancy = self.viewModel.vacancies[indexPath.row]
        
        let isFavourite = self.viewModel.isFavourite(vacancy: vacancy)
        
        cell.setup(vacancy: vacancy)
        cell.setup(isFavourite: isFavourite)
        
        return cell
        
    }

}

extension VacancyListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vacancy = self.viewModel.vacancies[indexPath.row]
        
        self.showPost(vacancy: vacancy)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let vacancy = self.viewModel.vacancies[indexPath.row]
        
        let favouriteTrailingAction = FavouriteTrailingAction()
        
        let action = favouriteTrailingAction.trailingAction(vacancy: vacancy) { [weak self] in
            self?.viewModel.addToFavourite(vacancy: vacancy)
        } remove: { [weak self] in
            self?.viewModel.removeFromFavourite(vacancy: vacancy)
        }

        let config = UISwipeActionsConfiguration(actions: [action])
        
        return config

    }
    
}
