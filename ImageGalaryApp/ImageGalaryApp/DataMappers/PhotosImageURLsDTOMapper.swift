//
//  PhotosImageURLsDTOMapper.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 4.01.24.
//

import Foundation

final class PhotosImageURLsDTOMapper: BaseDataMapper<PhotosImageURLsDTO, PhotosImageURLs> {

    override func map(object: PhotosImageURLsDTO) throws -> PhotosImageURLs {
        guard
            let full = object.full,
            let raw = object.raw,
            let regular = object.regular,
            let thumb = object.thumb,
            let small = object.small,
            let smallS3 = object.smallS3
        else {
            let error = NetworkError(error: "PhotosImageURLs mapping failed")
            throw error
        }

        return PhotosImageURLs(
            raw: raw,
            full: full,
            regular: regular,
            small: small,
            thumb: thumb,
            smallS3: smallS3
        )
    }
}
