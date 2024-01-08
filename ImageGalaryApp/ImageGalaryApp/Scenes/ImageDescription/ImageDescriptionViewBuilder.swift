//
//  ImageDescriptionViewBuilder.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 8.01.24.
//

import UIKit

final class ImageDescriptionViewBuilder {

    func produceImageDescriptionScene(
        favoriteImages: [FavoriteImageModel],
        uiData: [PhotoImageData],
        selectedIndex: Int
    ) -> ImageDescriptionView {
        let vc = SceneFactory.produceImageDescriptionController()
        let presenter = ImageDescriptionViewPresenter(vc: vc)
        let interactor = ImageDescriptionViewInteractor(
            presenter: presenter,
            favoritesImages: favoriteImages,
            uiData: uiData, 
            selectedIndex: selectedIndex,
            photoImageDataMapper: PhotoImageDataMapper(),
            photoImageDTOMapper: PhotoImageDTOMapper(),
            photoImagesDTOMapper: PhotosImagesDTOsMapper(),
            photosImageDataMapper: PhotosImagesDataMapper()
        )

        vc.interactor = interactor

        return vc
    }

}
