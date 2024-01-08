//
//  PhotoImageData.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 4.01.24.
//

import Foundation

struct PhotoImageData {
    let id: String
    let description: String
    let photosURLs: PhotosImageURLs
    let likes: Int
    let likedByUser: Bool
}

extension PhotoImageData {

    func modify(
        id: String? = nil,
        description: String? = nil,
        photosURLs: PhotosImageURLs? = nil,
        likes: Int? = nil,
        likedByUser: Bool? = nil
    ) -> PhotoImageData {

        return PhotoImageData(
            id: id ?? self.id,
            description: description ?? self.description,
            photosURLs: photosURLs ?? self.photosURLs,
            likes: likes ?? self.likes,
            likedByUser: likedByUser ?? self.likedByUser
        )
    }
}

