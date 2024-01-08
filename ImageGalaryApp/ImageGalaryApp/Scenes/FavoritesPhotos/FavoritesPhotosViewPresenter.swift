//
//  FavoritesPhotosViewPresenter.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 7.01.24.
//

import Foundation

protocol FavoritesPhotosViewPresenterProtocol: AnyObject {
    func updateWithURLs(_ cellsData: [ImageCellDataModel])
    func showDescriptionFor(
        photos: [FavoriteImageModel],
        selectedIndex: Int
    )
}

final class FavoritesPhotosViewPresenter: FavoritesPhotosViewPresenterProtocol {

    private weak var vc: FavoritesPhotosViewProtocol?

    init(vc: FavoritesPhotosViewProtocol) {
        self.vc = vc
    }

    func updateWithURLs(_ cellsData: [ImageCellDataModel]) {
        self.vc?.loadURLs(cellsData)
    }

    func showDescriptionFor(
        photos: [FavoriteImageModel],
        selectedIndex: Int
    ) {
        self.vc?.openDescriptionView(
            favoriteImages: photos,
            selectedIndex: selectedIndex
        )
    }
}
