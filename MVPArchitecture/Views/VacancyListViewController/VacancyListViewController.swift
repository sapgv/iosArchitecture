//
//  VacancyListViewController.swift
//  IosSolid
//
//  Created by Grigory Sapogov on 23.12.2023.
//

import UIKit

protocol IVacancyListViewController: UIViewController {
    
    func updateView()
    
    func updateViewFavourite(indexPath: IndexPath)
    
    func showError(error: Error)
    
}

final class VacancyListViewController: UIViewController {

    var presenter: IVacancyListPresenter!
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Vacancy"
        self.view.backgroundColor = .systemBackground
        self.presenter.view = self
        self.setupTableView()
        self.layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presenter.fetchFromStorage()
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
        
        self.presenter.update()
        
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

extension VacancyListViewController: IVacancyListViewController {
    
    func updateView() {
        
        self.endRefreshing()
        self.tableView.reloadData()
        
    }
    
    func updateViewFavourite(indexPath: IndexPath) {
        
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    func showError(error: Error) {
        
        print(error)
        
    }
    
    private func showVacancy(vacancy: IVacancy) {
        
        let presenter = VacancyDetailViewPresenter(vacancy: vacancy)
        let viewController = VacancyDetailViewController()
        viewController.presenter = presenter
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

extension VacancyListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter.vacancies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VacancyCell", for: indexPath) as? VacancyCell else { return UITableViewCell() }
        
        let vacancy = self.presenter.vacancies[indexPath.row]
        
        let isFavourite = self.presenter.isFavourite(vacancy: vacancy)
        
        cell.setup(vacancy: vacancy)
        cell.setup(isFavourite: isFavourite)
        
        return cell
        
    }

}

extension VacancyListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vacancy = self.presenter.vacancies[indexPath.row]
        
        self.showVacancy(vacancy: vacancy)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let vacancy = self.presenter.vacancies[indexPath.row]
        
        let favouriteTrailingAction = FavouriteTrailingAction()
        
        let action = favouriteTrailingAction.trailingAction(vacancy: vacancy) { [weak self] in
            self?.presenter.addToFavourite(vacancy: vacancy)
        } remove: { [weak self] in
            self?.presenter.removeFromFavourite(vacancy: vacancy)
        }

        let config = UISwipeActionsConfiguration(actions: [action])
        
        return config

    }
    
}
