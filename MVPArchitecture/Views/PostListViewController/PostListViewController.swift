//
//  PostListViewController.swift
//  IosSolid
//
//  Created by Grigory Sapogov on 23.12.2023.
//

import UIKit

protocol IPostListViewController: UIViewController {
    
    func updateView()
    
    func updateViewFavourite(indexPath: IndexPath)
    
    func showError(error: Error)
    
}

final class PostListViewController: UIViewController {

    var presenter: IPostListPresenter!
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Posts"
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
        self.tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        
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

extension PostListViewController: IPostListViewController {
    
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
    
    private func showPost(post: IPost) {
        
        let presenter = PostDetailViewPresenter(post: post)
        let viewController = PostDetailViewController()
        viewController.presenter = presenter
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

extension PostListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else { return UITableViewCell() }
        
        let post = self.presenter.posts[indexPath.row]
        
        let isFavourite = self.presenter.isFavourite(post: post)
        
        cell.setup(post: post)
        cell.setup(isFavourite: isFavourite)
        
        return cell
        
    }

}

extension PostListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = self.presenter.posts[indexPath.row]
        
        self.showPost(post: post)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let post = self.presenter.posts[indexPath.row]
        
        let favouriteTrailingAction = FavouriteTrailingAction()
        
        let action = favouriteTrailingAction.trailingAction(post: post) { [weak self] in
            self?.presenter.addToFavourite(post: post)
        } remove: { [weak self] in
            self?.presenter.removeFromFavourite(post: post)
        }

        let config = UISwipeActionsConfiguration(actions: [action])
        
        return config

    }
    
}
