//
//  ImagesListViewBuilder.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 7.01.24.
//

import Foundation

final class ImagesListViewBuilder {

    func produceImageListScene() -> ImagesListView {
        let stb = StoryboardScene.ImagesListView.storyboard//MainViewController.storyboard
        let vc = stb.instantiateViewController(withIdentifier: StoryboardScene.ImagesListView.storyboardName) as! ImagesListView
        let presenter = ImagesListViewPresenter(vc: vc)
        let repository = ImageListViewRepository(photoImageDataMapper: PhotosImagesDataMapper())
        let interactor = ImagesListViewInteractor(
            photoImagesDTOMapper: PhotosImagesDTOsMapper(),
            presenter: presenter,
            repository: repository,
            photoImageDataMapper: PhotoImageDataMapper(),
            photoImageDTOMapper: PhotoImageDTOMapper()
        )
        let router = ImagesListViewRouter(vc: vc)

        vc.interactor = interactor
        vc.router = router
        
        return vc
    }

}
