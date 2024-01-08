//
//  ImagesListViewMock.swift
//  ImageGalaryAppTests
//
//  Created by Nikita Moskalenko on 8.01.24.
//

import Foundation
import XCTest
@testable import ImageGalaryApp

final class ImagesListViewMock: ImagesListViewProtocol {

    var expectation: XCTestExpectation?

    var imageCellDataModel: [ImageCellDataModel] = []
    var favoriteImage: [PhotoImageData] = []
    var didShowProgress: Bool = false
    var didHideProgress: Bool = false
    var errorText: String? = nil

    func reloadCollectionView(with cellData: [ImageGalaryApp.ImageCellDataModel]) {
        self.imageCellDataModel = cellData
        self.expectation?.fulfill()
    }
    
    func showProgressHUD() {
        self.didShowProgress = true
        self.expectation?.fulfill()
    }
    
    func hideProgressHUD() {
        self.didHideProgress = true
        self.expectation?.fulfill()
    }

    func showDescription(uiData: [ImageGalaryApp.PhotoImageData], selectedIndex: Int) {
        self.favoriteImage.append(contentsOf: uiData)
        self.expectation?.fulfill()
    }

    func showError(text: String) {
        self.errorText = text
        self.expectation?.fulfill()
    }
}
