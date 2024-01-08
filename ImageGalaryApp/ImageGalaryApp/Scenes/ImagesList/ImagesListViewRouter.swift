//
//  ImagesListViewRouter.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 8.01.24.
//

import UIKit

protocol ImagesListViewRouterProtocol: AnyObject {

    func showImageDescription(uiData: [PhotoImageData], selectedIndex: Int)
}

final class ImagesListViewRouter: ImagesListViewRouterProtocol {

    private weak var vc: ImagesListView?

    init(vc: ImagesListView) {
        self.vc = vc
    }

    func showImageDescription(uiData: [PhotoImageData], selectedIndex: Int) {
        let vc = ImageDescriptionViewBuilder().produceImageDescriptionScene(
            favoriteImages: [],
            uiData: uiData,
            selectedIndex: selectedIndex
        )
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .flipHorizontal
        self.vc?.present(navVC, animated: true)
    }
}
