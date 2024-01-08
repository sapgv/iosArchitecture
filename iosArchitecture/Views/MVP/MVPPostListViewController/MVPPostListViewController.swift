//
//  MVPPostListViewController.swift
//  IosSolid
//
//  Created by Grigory Sapogov on 23.12.2023.
//

import UIKit

protocol IMVPPostListViewController: UIViewController {
    
    func updateView()
    
    func showError(error: Error)
    
}

final class MVPPostListViewController: UIViewController {

    var presenter: IMVPPostListPresenter!
    
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

extension MVPPostListViewController: IMVPPostListViewController {
    
    func updateView() {
        
        self.endRefreshing()
        self.tableView.reloadData()
        
    }
    
    func showError(error: Error) {
        
        print(error)
        
    }
    
    private func showPost(post: IPost) {
        
        let presenter = PostDetailViewPresenter(post: post)
        let viewController = MVPPostDetailViewController()
        viewController.presenter = presenter
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}

extension MVPPostListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else { return UITableViewCell() }
        
        let post = self.presenter.posts[indexPath.row]
        
        cell.setup(post: post)
        
        return cell
        
    }

}

extension MVPPostListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = self.presenter.posts[indexPath.row]
        
        self.showPost(post: post)
        
    }
    
    
}
