//
//  FavoritesPhotosViewInateractor.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 7.01.24.
//

import Foundation
import Resolver

protocol FavoritesPhotosViewInateractorProtocol: AnyObject {

    func loadFavoritesImages()
    func removeFromFavoritesImage(at index: Int)
    func requestImageDescriptionAt(index: Int) 
}

final class FavoritesPhotosViewInateractor: FavoritesPhotosViewInateractorProtocol {

    @Injected private var userDefaultsManager: UserDefaultsManagerProtocol

    private let presenter: FavoritesPhotosViewPresenterProtocol
    private var favoritesPhotos: [FavoriteImageModel] = []

    init(presenter: FavoritesPhotosViewPresenterProtocol) {
        
        self.presenter = presenter
    }

    func loadFavoritesImages() {
        guard 
            var images = self.userDefaultsManager.getObject(for: .isFavorite, castTo: [FavoriteImageModel].self)
        else { return }

        images.removeAll(where: { $0.photoId == nil || $0.thumbUrl == nil })
        
        self.favoritesPhotos = images

        let cellsData: [ImageCellDataModel] = self.favoritesPhotos.compactMap { favoriteImage -> ImageCellDataModel? in
            guard 
                let url = favoriteImage.thumbUrl,
                let likes = favoriteImage.likes,
                let id = favoriteImage.photoId
            else { return nil }
            return .init(
                photoId: id,
                imageUrl: url,
                likes: likes,
                likedByUser: false,
                isFavorite: true
            )
        }

        let cleanedData: [ImageCellDataModel] = Array(Set(cellsData))

        self.presenter.updateWithURLs(cleanedData)
    }

    func requestImageDescriptionAt(index: Int) {
        self.presenter.showDescriptionFor(photos: self.favoritesPhotos, selectedIndex: index)
    }

    func removeFromFavoritesImage(at index: Int) {
        let image = favoritesPhotos[index]
        var favoritesImageURLs = self.userDefaultsManager.getObject(for: .isFavorite, castTo: [FavoriteImageModel].self) ?? []
        favoritesImageURLs.removeAll(where: { $0.photoId == image.photoId })
        self.userDefaultsManager.setObject(favoritesImageURLs, for: .isFavorite)
    }
}
