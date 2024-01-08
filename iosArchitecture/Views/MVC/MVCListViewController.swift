//
//  MVCListViewController.swift
//  iosArchitecture
//
//  Created by Grigory Sapogov on 31.12.2023.
//

import UIKit

final class MVCListViewController: UIViewController {

    private var posts: [IPost] = []
    
    private var tableView: UITableView!
    
    var storage: IStorage!
    
    var api: IApi!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Posts"
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
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        
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

extension MVCListViewController {
    
    private func fetchFromStorage() {
        
        self.storage.fetchFromStorage { [weak self] result in
            
            switch result {
            case let .failure(error):
                DispatchQueue.main.async {
                    self?.showError(error: error)
                }
            case let .success(posts):
                self?.posts = posts
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

extension MVCListViewController: IMVPPostListViewController {
    
    func updateView() {
        
        self.endRefreshing()
        self.tableView.reloadData()
        
    }
    
    func showError(error: Error) {
        
        print(error)
        
    }
    
}

extension MVCListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else { return UITableViewCell() }
        
        let post = self.posts[indexPath.row]
        
        cell.setup(post: post)
        
        return cell
        
    }

}
