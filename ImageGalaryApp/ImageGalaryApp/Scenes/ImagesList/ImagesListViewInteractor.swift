//
//  ImagesListViewInteractor.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 3.01.24.
//

import Foundation
import Resolver

protocol ImagesListViewInteractorProtocol: AnyObject {
    func requestData()
    func addToFavoriteImage(at index: Int)
    func removeFromFavoritesImage(at index: Int)
    func requestImageDescriptionAt(index: Int)
}

final class ImagesListViewInteractor: ImagesListViewInteractorProtocol {

    @Injected private var networkService: NetworkServiceProtocol
    @Injected private var userDefaultsManager: UserDefaultsManagerProtocol

    private let photoImagesDTOMapper: PhotosImagesDTOsMapper
    private let presenter: ImagesListViewPresenterProtocol
    private let repository: ImageListViewRepositoryProtocol
    private let photoImageDataMapper: PhotoImageDataMapper
    private let photoImageDTOMapper: PhotoImageDTOMapper

    private var currentPage: Int = 0
    private var requestInProgress: Bool = false

    init(
        photoImagesDTOMapper: PhotosImagesDTOsMapper,
        presenter: ImagesListViewPresenterProtocol,
        repository: ImageListViewRepositoryProtocol,
        photoImageDataMapper: PhotoImageDataMapper,
        photoImageDTOMapper: PhotoImageDTOMapper
    ) {
        self.photoImagesDTOMapper = photoImagesDTOMapper
        self.presenter = presenter
        self.repository = repository
        self.photoImageDataMapper = photoImageDataMapper
        self.photoImageDTOMapper = photoImageDTOMapper
    }

    func requestImageDescriptionAt(index: Int) {
        self.presenter.prepareSelectedImageToDisplay(
            uiData: self.repository.getAllStorage(),
            selectedIndex: index
        )
    }

    func addToFavoriteImage(at index: Int) {
        let image = self.repository.photoAt(index: index)
        var favoritesImageURLs = self.userDefaultsManager.getObject(for: .isFavorite, castTo: [FavoriteImageModel].self) ?? []

        if favoritesImageURLs.contains(where: { image.id == $0.photoId ?? "" }) { return }

        favoritesImageURLs.append(
            .init(
                photoId: image.id,
                thumbUrl: image.photosURLs.thumb,
                fullImageUrl: image.photosURLs.regular,
                likes: image.likes,
                description: image.description,
                isFavorite: true, imageData: nil
            )
        )

        favoritesImageURLs.removeAll(where: { $0.photoId == nil || $0.thumbUrl == nil })

        self.userDefaultsManager.setObject(favoritesImageURLs, for: .isFavorite)
    }

    func removeFromFavoritesImage(at index: Int) {
        let image = self.repository.photoAt(index: index)
        var favoritesImageURLs = self.userDefaultsManager.getObject(for: .isFavorite, castTo: [FavoriteImageModel].self) ?? []
        favoritesImageURLs.removeAll(where: { ($0.photoId ?? "") == image.id })
        let cleanData = Array(Set(favoritesImageURLs))
        self.userDefaultsManager.setObject(cleanData, for: .isFavorite)
    }

    func requestData() {
        self.currentPage += 1

        guard
            self.repository.photoImageData(for: self.currentPage) == nil
        else {
            let uiData = self.repository.photoImageData(for: self.currentPage)!
            self.presenter.preparePhotsUIData(
                photos: uiData,
                favoritesPhotos: self.userDefaultsManager.getObject(for: .isFavorite, castTo: [FavoriteImageModel].self) ?? []
            )
            return
        }

        if self.requestInProgress == false {
            self.downloadData()
        }
    }
}

private extension ImagesListViewInteractor {
    
    func downloadData() {

        self.requestInProgress = true
        self.presenter.showProgressHUD()

        self.networkService.request(
            url: .photosList,
            httpMethod: .get,
            params: [
                "page" : currentPage.description,
                "client_id" : ConfigurationPrivacy.access_token,
                "per_page" : 30
            ]) { [weak self] response in
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
                    try self.repository.addPhotoImageData(for: self.currentPage, data: data)
                } catch (let error) {
                    self.presenter.hideProgressHUD()
                    self.requestInProgress = false
                    self.presenter.showError(NetworkError(error: error.localizedDescription))
                    return
                }

                let uiData = self.repository.photoImageData(for: self.currentPage)!
                self.presenter.preparePhotsUIData(
                    photos: uiData,
                    favoritesPhotos: self.userDefaultsManager.getObject(for: .isFavorite, castTo: [FavoriteImageModel].self) ?? []
                )

            } onFailure: { [weak self] networkError in
                guard let self else { return }

                self.presenter.hideProgressHUD()
                self.requestInProgress = false
                self.presenter.showError(networkError)

            }
    }
}
