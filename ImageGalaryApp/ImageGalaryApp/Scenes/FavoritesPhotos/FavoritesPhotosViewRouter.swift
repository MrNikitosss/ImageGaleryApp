//
//  FavoritesPhotosViewRouter.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 8.01.24.
//

import UIKit

protocol FavoritesPhotosViewRouterProtocol: AnyObject {

    func showImageDescription(
        favoriteImages: [FavoriteImageModel],
        selectedIndex: Int
    )
}

final class FavoritesPhotosViewRouter: FavoritesPhotosViewRouterProtocol {

    private weak var vc: FavoritesPhotosView?

    init(vc: FavoritesPhotosView) {
        self.vc = vc
    }

    func showImageDescription(
        favoriteImages: [FavoriteImageModel],
        selectedIndex: Int
    ) {
        let vc = ImageDescriptionViewBuilder().produceImageDescriptionScene(
            favoriteImages: favoriteImages,
            uiData: [],
            selectedIndex: selectedIndex
        )
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .flipHorizontal
        self.vc?.present(navVC, animated: true)
    }
}
