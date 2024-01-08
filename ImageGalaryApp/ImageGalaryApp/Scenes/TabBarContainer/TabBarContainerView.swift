//
//  TabBarContainerView.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 7.01.24.
//

import UIKit

final class TabBarContainerView: UITabBarController {


    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewControllers = [
            self.createNavController(for: ImagesListViewBuilder().produceImageListScene(), title: "Photos", image: UIImage(systemName: "list.bullet.circle"), selectedImage: UIImage(systemName: "list.bullet.circle.fill")),
            self.createNavController(for: FavoritesPhotosViewBuilder().produceFavoritesPhotosScene(), title: "Favorites", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        ]
    }

    func createNavController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage?,
        selectedImage: UIImage?
    ) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
}
