//
//  SceneDelegate.swift
//  MVCArchitecture
//
//  Created by Grigory Sapogov on 09.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: scene)
        
        self.window?.rootViewController = self.createViewController()
        self.window?.makeKeyAndVisible()
        
    }

    private func createViewController() -> UIViewController {
        
        //Vacancies

        let vacancyListViewController = VacancyListViewController()
        vacancyListViewController.storage = VacancyStorage.shared
        vacancyListViewController.api = Api()
        
        let vacancyListNavigationController = UINavigationController(rootViewController: vacancyListViewController)
        vacancyListNavigationController.tabBarItem = UITabBarItem(title: "Posts", image: UIImage(systemName: "newspaper"), tag: 0)
        
        //Favourite
        
        let favouriteVacancyListViewController = FavouriteVacancyListViewController()
        favouriteVacancyListViewController.storage = VacancyStorage.shared
        
        let favouriteVacancyListNavigationController = UINavigationController(rootViewController: favouriteVacancyListViewController)
        favouriteVacancyListNavigationController.tabBarItem = UITabBarItem(title: "Favourite", image: UIImage(systemName: "heart.fill"), tag: 1)
        
        let tabBarViewController = TabBarController()
        tabBarViewController.setViewControllers([vacancyListNavigationController, favouriteVacancyListNavigationController], animated: false)
        
        return tabBarViewController
        
    }

}

