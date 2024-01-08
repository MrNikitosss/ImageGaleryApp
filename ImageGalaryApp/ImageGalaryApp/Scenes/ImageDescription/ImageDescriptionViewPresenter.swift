//
//  ImageDescriptionViewPrestenter.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 7.01.24.
//

import Foundation

protocol ImageDescriptionViewPresenterProtocol: AnyObject {

    func updateViewWith(items: [FavoriteImageModel])
    func showProgressHUD()
    func hideProgressHUD()
    func showError(_ error: NetworkError)
}

final class ImageDescriptionViewPresenter: ImageDescriptionViewPresenterProtocol {

    weak var vc: ImageDescriptionViewProtocol?

    init(vc: ImageDescriptionViewProtocol) {
        self.vc = vc
    }

    func updateViewWith(items: [FavoriteImageModel]) {
        self.vc?.setItems(items: items)
    }
//
//    func updateViewWithFavorite(
//        image: FavoriteImageModel
//    ) {
//        self.vc?.updateCurrentItem(image)
//    }
//
//    func setItemsCount(_ count: Int) {
//        self.vc?.updateItemsCount(count)
//    }
//
//    func setItem(_ item: PhotoImageData, isFavorite: Bool) {
//        self.vc?.updateCurrentItem(FavoriteImageModel(photoId: item.id, thumbUrl: item.photosURLs.thumb, fullImageUrl: item.photosURLs.regular, likes: item.likes, description: item.description, isFavorite: isFavorite, imageData: nil))
//    }

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
