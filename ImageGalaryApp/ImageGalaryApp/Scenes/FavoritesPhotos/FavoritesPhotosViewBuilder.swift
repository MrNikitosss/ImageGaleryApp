//
//  FavoritesPhotosViewBuilder.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 7.01.24.
//

import Foundation

final class FavoritesPhotosViewBuilder {

    func produceFavoritesPhotosScene() -> FavoritesPhotosView {
        let vc = SceneFactory.produceFavoritesImagesController()
        let presenter = FavoritesPhotosViewPresenter(vc: vc)
        let interactor = FavoritesPhotosViewInateractor(presenter: presenter)
        let router = FavoritesPhotosViewRouter(vc: vc)

        vc.interactor = interactor
        vc.router = router

        return vc
    }

}
