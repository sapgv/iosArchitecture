//
//  FavouritePostListViewController.swift
//  iosArchitecture
//
//  Created by Grigory Sapogov on 08.01.2024.
//

import UIKit

protocol IFavouritePostListViewController: UIViewController {
    
    func updateView()
    
    func showError(error: Error)
    
}

final class FavouritePostListViewController: UIViewController {
    
    var presenter: IFavouritePostListPresenter!
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favourite"
        self.view.backgroundColor = .systemBackground
        self.presenter.view = self
        self.setupTableView()
        self.presenter.fetchFavourites()
        self.layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.presenter.favouritesNeedUpdate {
            self.update()
        }
    }

    private func setupTableView() {
        
        self.tableView = UITableView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        
    }
    
    @objc
    private func refresh() {
        
        self.update()
        
    }
    
    private func update() {
        
        self.presenter.fetchFavourites()
        
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

extension FavouritePostListViewController: IFavouritePostListViewController {
    
    func updateView() {
        
        self.endRefreshing()
        self.tableView.reloadData()
        
    }
    
    func showError(error: Error) {
        
        print(error)
        
    }
    
}

extension FavouritePostListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else { return UITableViewCell() }
        
        let post = self.presenter.posts[indexPath.row]
        
        cell.setup(post: post)
//        cell.set(isFavourite: self.presenter.isf)
        
        return cell
        
    }

}

extension FavouritePostListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = self.presenter.posts[indexPath.row]
        
//        self.showPost(post: post)
        
    }
    
    
}
