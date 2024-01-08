//
//  ImageListViewRepository.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 4.01.24.
//

import Foundation

protocol ImageListViewRepositoryProtocol: AnyObject {

    func addPhotoImageData(for page: Int, data: [PhotoImageDTO]) throws
    func photoImageData(for page: Int) -> [PhotoImageData]?
    func photoAt(index: Int) -> PhotoImageData
    func cleanStorage()
    func getAllStorage() -> [PhotoImageData] 
}

final class ImageListViewRepository: ImageListViewRepositoryProtocol {

    private var localStorage: [Int : [PhotoImageData]] = [:]
    private let photoImageDataMapper: PhotosImagesDataMapper

    init(photoImageDataMapper: PhotosImagesDataMapper) {
        self.photoImageDataMapper = photoImageDataMapper
    }

    func addPhotoImageData(
        for page: Int,
        data: [PhotoImageDTO]
    ) throws {
        let uiData = try self.photoImageDataMapper.map(object: data)
        self.localStorage[page] = uiData
    }

    func getAllStorage() -> [PhotoImageData] {
        return self.localStorage.map({ $0.value }).reduce([], +)
    }

    func photoImageData(for page: Int) -> [PhotoImageData]? {
        self.localStorage[page]
    }

    func photoAt(index: Int) -> PhotoImageData {
        self.localStorage.map { $0.value }.reduce([], +)[index]
    }

    func cleanStorage() {
        self.localStorage.removeAll()
    }
}
