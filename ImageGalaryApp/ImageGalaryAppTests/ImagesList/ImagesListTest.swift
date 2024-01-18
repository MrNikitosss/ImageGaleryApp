//
//  ImagesListTest.swift
//  ImageGalaryAppTests
//
//  Created by Nikita Moskalenko on 8.01.24.
//

import XCTest
import Resolver
@testable import ImageGalaryApp

final class ImagesListTest: XCTestCase {

    @LazyInjected private var networkManager: MockNetWorkManager
    @LazyInjected private var userDefaultsManager: MockUserDefaultsService

    private var vc: ImagesListViewMock!
    private var presenter: ImagesListViewPresenterProtocol!
    private var interactor: ImagesListViewInteractorProtocol!
    private var repository: ImageListViewRepositoryProtocol!

    override func setUp() {
        super.setUp()

        Resolver.registerMockServices()

        self.vc = ImagesListViewMock()
        self.presenter = ImagesListViewPresenter(vc: self.vc)
        self.repository = ImageListViewRepository(photoImageDataMapper: PhotosImagesDataMapper())
        self.interactor = ImagesListViewInteractor(
            photoImagesDTOMapper: PhotosImagesDTOsMapper(),
            presenter: self.presenter,
            repository: self.repository,
            photoImageDataMapper: PhotoImageDataMapper(),
            photoImageDTOMapper: PhotoImageDTOMapper()
        )
    }

    override func tearDown() {
        super.tearDown()

        self.vc = nil
        self.presenter = nil
        self.interactor = nil
        self.repository = nil
    }

    func testLoadDataSuccess() {
        //when
        let expectation = XCTestExpectation(description: "Cell data load successfully")
        expectation.expectedFulfillmentCount = 3
        self.vc.expectation = expectation

        //given
        self.networkManager.result = .success(data: MockImagesListFirstPage.data(using: .utf8) ?? Data())
        self.interactor.requestData()
        self.wait(for: [expectation], timeout: 3)

        //then
        XCTAssertNotNil(self.repository.photoImageData(for: 1), "Images arr empty")
        XCTAssertFalse((self.repository.photoImageData(for: 1) ?? []).isEmpty, "Images arr empty")
        XCTAssertTrue(self.vc.didHideProgress, "Progress HUD wasn't hided")
        XCTAssertTrue(self.vc.imageCellDataModel.isEmpty == false, "Something wrong")
    }

    func testDTODataMapper() {
        //when
        let expectation = XCTestExpectation(description: "Cell data load failure")
        expectation.expectedFulfillmentCount = 3
        self.vc.expectation = expectation

        //given
        self.networkManager.result = .success(data: MockImageListMissedData.data(using: .utf8) ?? Data())
        self.interactor.requestData()
        self.wait(for: [expectation], timeout: 3)

        //then
        XCTAssertNotNil(self.vc.errorText, "Error didn't display")
        XCTAssertEqual(self.vc.errorText ?? "", "PhotoImageDTO mapping failed")
    }

    func testUIDataMapperFailedMissedIds() {
        //when
        let expectation = XCTestExpectation(description: "Cell data load failure")
        expectation.expectedFulfillmentCount = 3
        self.vc.expectation = expectation

        //given
        self.networkManager.result = .success(data: MockImagesListMissedPhotosIds.data(using: .utf8) ?? Data())
        self.interactor.requestData()
        self.wait(for: [expectation], timeout: 3)

        //then
        XCTAssertNotNil(self.vc.errorText, "Error didn't display")
        XCTAssertEqual(self.vc.errorText ?? "", "PhotosImagesDataMapper mapping failed, missed: id")
    }

    func testAddToFavoritesSuccess() {
        //when
        let expectation = XCTestExpectation(description: "Cell data load successfully")
        expectation.expectedFulfillmentCount = 3
        self.vc.expectation = expectation

        //given
        self.networkManager.result = .success(data: MockImagesListFirstPage.data(using: .utf8) ?? Data())
        self.interactor.requestData()
        self.interactor.addToFavoriteImage(at: 1)
        self.interactor.addToFavoriteImage(at: 3)
        self.interactor.addToFavoriteImage(at: 5)
        self.wait(for: [expectation], timeout: 3)


        //then
        XCTAssertNotNil(self.userDefaultsManager.getObject(for: .isFavorite, castTo: [FavoriteImageModel].self))

        //when
        let showDescriptionSceneExpecxtation = XCTestExpectation(description: "Tap on show details photo")
        self.vc.expectation = showDescriptionSceneExpecxtation

        //given
        self.interactor.requestImageDescriptionAt(index: 3)
        self.wait(for: [showDescriptionSceneExpecxtation], timeout: 3)

        //then
        XCTAssertNotNil(self.vc.favoriteImage, "Oops...")
        XCTAssertEqual(self.vc.favoriteImage[3].id, "KfDbyu55qyY", "Photo id's isn't equal")
    }

    func testRemoveFromFavorites() {
        //when
        let expectation = XCTestExpectation(description: "Cell data load successfully")
        expectation.expectedFulfillmentCount = 3
        self.vc.expectation = expectation

        //given
        self.networkManager.result = .success(data: MockImagesListFirstPage.data(using: .utf8) ?? Data())
        self.interactor.requestData()
        self.interactor.addToFavoriteImage(at: 1)
        self.interactor.addToFavoriteImage(at: 3)
        self.interactor.addToFavoriteImage(at: 5)
        self.interactor.removeFromFavoritesImage(at: 3)
        self.wait(for: [expectation], timeout: 3)

        //then
        let objects = self.userDefaultsManager.getObject(for: .isFavorite, castTo: [FavoriteImageModel].self)
        XCTAssertNotNil(objects, "Oops...")
        XCTAssertTrue((objects?.count ?? 0) > 0, "Favorites images count is zero")
        XCTAssertNil(objects?.filter({ ($0.photoId ?? "") == "KfDbyu55qyY" }).first)
    }
}
