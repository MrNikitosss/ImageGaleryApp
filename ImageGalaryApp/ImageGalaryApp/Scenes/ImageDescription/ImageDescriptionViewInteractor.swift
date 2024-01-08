//
//  ImageDescriptionViewInteractor.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 7.01.24.
//

import Foundation
import Resolver
import Alamofire

protocol ImageDescriptionViewInteractorProtocol: AnyObject {

    func initialUpdate()
    func removeFromFavoritesImage(at index: Int)
    func loadImages()
}

final class ImageDescriptionViewInteractor: ImageDescriptionViewInteractorProtocol {

    @Injected private var networkService: NetworkServiceProtocol
    @Injected private var userDefaultsManager: UserDefaultsManagerProtocol
    
    private let photosImageDataMapper: PhotosImagesDataMapper
    private let presenter: ImageDescriptionViewPresenterProtocol
    private let photoImageDataMapper: PhotoImageDataMapper
    private let photoImageDTOMapper: PhotoImageDTOMapper
    private let photoImagesDTOMapper: PhotosImagesDTOsMapper
    private var currentPage: Int = 0
    private var requestInProgress: Bool = false
    private var selectedIndex: Int
    private var isFavoritesList: Bool = false
    private var localRepository: [FavoriteImageModel] = []

    init(
        presenter: ImageDescriptionViewPresenterProtocol,
        favoritesImages: [FavoriteImageModel],
        uiData: [PhotoImageData],
        selectedIndex: Int,
        photoImageDataMapper: PhotoImageDataMapper,
        photoImageDTOMapper: PhotoImageDTOMapper,
        photoImagesDTOMapper: PhotosImagesDTOsMapper,
        photosImageDataMapper: PhotosImagesDataMapper
    ) {

        self.presenter = presenter
        self.selectedIndex = selectedIndex
        self.photoImageDataMapper = photoImageDataMapper
        self.photoImageDTOMapper = photoImageDTOMapper
        self.photoImagesDTOMapper = photoImagesDTOMapper
        self.photosImageDataMapper = photosImageDataMapper

        self.localRepository = {
            if uiData.isEmpty == false {
                self.isFavoritesList = false
                return uiData.map { item in
                    FavoriteImageModel(
                        photoId: item.id,
                        thumbUrl: item.photosURLs.thumb,
                        fullImageUrl: item.photosURLs.regular,
                        likes: item.likes,
                        description: item.description,
                        isFavorite: self.isFavoriteImage(itemId: item.id),
                        imageData: nil
                    )
                }
            } else {
                self.isFavoritesList = true
                return favoritesImages
            }
        }()
    }

    func isFavoriteImage(itemId: String) -> Bool {
        (self.userDefaultsManager.getObject(for: "favorites", castTo: [FavoriteImageModel].self) ?? []).contains(where: { $0.photoId == itemId })
    }

    func initialUpdate() {
        self.presenter.updateViewWith(items: self.localRepository)
    }

    func loadImages() {
        guard self.isFavoritesList == false else { return }
        self.requestInProgress = true

        self.currentPage += 1

        self.networkService.request(
            url: .photosList,
            httpMethod: .get,
            params: ["page" : currentPage,
                 "client_id" : ConfigurationPrivacy.access_token,
                 "per_page" : 30])
        { [weak self] response in
            guard let self else { return }

            self.presenter.hideProgressHUD()
            self.requestInProgress = false

            var data: [PhotoImageDTO] = []

            do {
                data = try self.photoImagesDTOMapper.map(object: response)
            } catch (let error) {
                self.presenter.hideProgressHUD()
                self.requestInProgress = false
                self.presenter.showError(NetworkError(error: error.localizedDescription))
                return
            }

            do {
                let tempData = try self.photosImageDataMapper.map(object: data)
                self.localRepository.append(contentsOf: tempData.map { .init(
                    photoId: $0.id,
                    thumbUrl: $0.photosURLs.thumb,
                    fullImageUrl: $0.photosURLs.regular,
                    likes: $0.likes,
                    description: $0.description,
                    isFavorite: self.isFavoriteImage(itemId: $0.id),
                    imageData: nil
                )
                })
            } catch (let error) {
                self.presenter.hideProgressHUD()
                self.requestInProgress = false
                self.presenter.showError(NetworkError(error: error.localizedDescription))
                return
            }

            self.presenter.updateViewWith(items: self.localRepository)


        } onFailure: { [weak self] error in
            guard let self else { return }
            
            self.presenter.hideProgressHUD()
            self.requestInProgress = false
            self.presenter.showError(NetworkError(error: error.localizedDescription))
        }
    }

    func removeFromFavoritesImage(at index: Int) {
//        var favoritesImageURLs = self.userDefaultsManager.getObject(for: "favorites", castTo: [FavoriteImageModel].self) ?? []
//        favoritesImageURLs.removeAll(where: { $0.photoId == self.favoritesImages[index].photoId })
//        self.favoritesImages[index] = self.favoritesImages[index].modify(isFavorite: false)
//        self.userDefaultsManager.setObject(self.favoritesImages, for: "favorites")
    }

}
