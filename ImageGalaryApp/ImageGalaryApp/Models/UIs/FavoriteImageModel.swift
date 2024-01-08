//
//  FavoriteImageModel.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 8.01.24.
//

import Foundation

struct FavoriteImageModel {
    let photoId: String?
    let thumbUrl: String?
    let fullImageUrl: String?
    let likes: Int?
    let description: String?
    let isFavorite: Bool
    let imageData: Data?
}

extension FavoriteImageModel: Hashable {}

extension FavoriteImageModel {

    func modify(
        photoId: String? = nil,
        thumbUrl: String? = nil,
        fullImageUrl: String? = nil,
        likes: Int? = nil,
        description: String? = nil,
        isFavorite: Bool? = nil,
        imageData: Data? = nil
    ) -> FavoriteImageModel {
        return FavoriteImageModel(
            photoId: photoId ?? self.photoId,
            thumbUrl: thumbUrl ?? self.thumbUrl,
            fullImageUrl: fullImageUrl ?? self.fullImageUrl,
            likes: likes ?? self.likes,
            description: description ?? self.description,
            isFavorite: isFavorite ?? self.isFavorite,
            imageData: imageData ?? self.imageData
        )

    }
}

extension FavoriteImageModel: Codable {
    enum CodingKeys: String, CodingKey {
        case photoId
        case thumbUrl
        case likes
        case fullImageUrl
        case description
        case isFavorite
        case imageData
    }

    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)

        self.photoId = try? container?.decodeIfPresent(String.self, forKey: .photoId)
        self.thumbUrl = try? container?.decodeIfPresent(String.self, forKey: .thumbUrl)
        self.likes = try? container?.decodeIfPresent(Int.self, forKey: .likes)
        self.description = try? container?.decodeIfPresent(String.self, forKey: .description)
        self.fullImageUrl = try? container?.decodeIfPresent(String.self, forKey: .fullImageUrl)
        self.isFavorite = (try? container?.decodeIfPresent(Bool.self, forKey: .isFavorite)) ?? false
        self.imageData = try? container?.decodeIfPresent(Data.self, forKey: .imageData)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.photoId, forKey: .photoId)
        try container.encodeIfPresent(self.thumbUrl, forKey: .thumbUrl)
        try container.encodeIfPresent(self.likes, forKey: .likes)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.fullImageUrl, forKey: .fullImageUrl)
        try container.encodeIfPresent(self.isFavorite, forKey: .isFavorite)
        try container.encodeIfPresent(self.imageData, forKey: .imageData)
    }
}
