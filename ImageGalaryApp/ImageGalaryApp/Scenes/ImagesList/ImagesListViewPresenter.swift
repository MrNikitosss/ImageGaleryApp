//
//  ImagesListViewPresenter.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 4.01.24.
//

import Foundation
import Resolver

protocol ImagesListViewPresenterProtocol: AnyObject {
    init(vc: ImagesListViewProtocol)
    
    func prepareSelectedImageToDisplay(
        uiData: [PhotoImageData],
        selectedIndex: Int
    )
    func preparePhotsUIData(photos: [PhotoImageData], favoritesPhotos: [FavoriteImageModel])
    func showError(_ error: NetworkError)
    func showProgressHUD()
    func hideProgressHUD()
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {

    private weak var vc: ImagesListViewProtocol?

    init(vc: ImagesListViewProtocol) {
        self.vc = vc
    }

    func prepareSelectedImageToDisplay(
        uiData: [PhotoImageData],
        selectedIndex: Int
    ) {
        self.vc?.showDescription(uiData: uiData, selectedIndex: selectedIndex)
    }

    func preparePhotsUIData(
        photos: [PhotoImageData],
        favoritesPhotos: [FavoriteImageModel]
    ) {
        let cellData = photos.map { photo in

            let isFavorite: Bool = {
                guard
                    favoritesPhotos.first(where: { $0.photoId ?? "" == photo.id }) != nil
                else { return false }
                return true
            }()

            return ImageCellDataModel(
                photoId: photo.id,
                imageUrl: photo.photosURLs.thumb,
                likes: photo.likes,
                likedByUser: photo.likedByUser,
                isFavorite: isFavorite
            )
        }
        self.vc?.reloadCollectionView(with: cellData)
    }

    func showError(_ error: NetworkError) {
        self.vc?.showError(text: error.localizedDescription)
    }

    func showProgressHUD() {
        self.vc?.showProgressHUD()
    }

    func hideProgressHUD() {
        self.vc?.hideProgressHUD()
    }
}
