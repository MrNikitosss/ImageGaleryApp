//
//  ImageCellDataModel.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 8.01.24.
//

import Foundation

struct ImageCellDataModel {
    let photoId: String
    let imageUrl: String
    let likes: Int
    let likedByUser: Bool
    let isFavorite: Bool
}

extension ImageCellDataModel {

    func modify(
        photoId: String? = nil,
        imageURL: String? = nil,
        likes: Int? = nil,
        likedByUser: Bool? = nil,
        isFavorite: Bool? = nil
    ) -> ImageCellDataModel {
        return ImageCellDataModel(
            photoId: photoId ?? self.photoId,
            imageUrl: imageURL ?? self.imageUrl,
            likes: likes ?? self.likes,
            likedByUser: likedByUser ?? self.likedByUser,
            isFavorite: isFavorite ?? self.isFavorite
        )
    }
}

extension ImageCellDataModel: Hashable {}
