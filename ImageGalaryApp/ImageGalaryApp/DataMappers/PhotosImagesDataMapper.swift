//
//  PhotoImageDataMapper.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 3.01.24.
//

import Foundation

struct PhotosImagesDataMapper: BaseDataMapper {

    func map(object: [PhotoImageDTO]) throws -> [PhotoImageData] {
        let photosURLsMapper = PhotosImageURLsDTOMapper()

        var arr: [PhotoImageData] = []

        try object.forEach { photoImage in
            guard
                let id = photoImage.id,
                let photosURLsDTO = photoImage.photosURLsDTO,
                let photosURLs = try? photosURLsMapper.map(object: photosURLsDTO),
                let likes = photoImage.likes
            else {
                var incomingParametr: String {
                    if photoImage.id == nil {
                        return "id"
                    }

                    if photoImage.photosURLsDTO == nil {
                        return "photos URLs"
                    }

                    if photoImage.likes == nil {
                        return "likes"
                    }

                    return "Unexpected error"
                }
                let error = NetworkError(error: "PhotosImagesDataMapper mapping failed, missed: \(incomingParametr)")
                throw error
            }

            arr.append(PhotoImageData(
                id: id,
                description: photoImage.description ?? "",
                photosURLs: photosURLs,
                likes: likes,
                likedByUser: photoImage.likedByUser
            ))
        }

        return arr
    }
}

struct PhotoImageDataMapper: BaseDataMapper {

    func map(object: PhotoImageDTO) throws -> PhotoImageData {
        let photosURLsMapper = PhotosImageURLsDTOMapper()

            guard
                let id = object.id,
                let photosURLsDTO = object.photosURLsDTO,
                let photosURLs = try? photosURLsMapper.map(object: photosURLsDTO),
                let likes = object.likes
            else {
                let error = NetworkError(error: "PhotoImageDataMapper mapping failed")
                throw error
            }

        return PhotoImageData(
            id: id,
            description: object.description ?? "",
            photosURLs: photosURLs,
            likes: likes,
            likedByUser: object.likedByUser
        )
    }
}
