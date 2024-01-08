//
//  PhotoImageDTO.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 4.01.24.
//

import Foundation


struct PhotoImageDTO {
    let id: String?
    let description: String?
    let photosURLsDTO: PhotosImageURLsDTO?
    let likes: Int?
    let likedByUser: Bool
}

extension PhotoImageDTO: Codable {

    enum CodingKeys: String, CodingKey {
        case id
        case description
        case photosURLsDTO = "urls"
        case likes
        case likedByUser = "liked_by_user"
    }

    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)

        self.id = try? container?.decodeIfPresent(String.self, forKey: .id)
        self.description = try? container?.decodeIfPresent(String.self, forKey: .description)
        self.photosURLsDTO = try? container?.decodeIfPresent(PhotosImageURLsDTO.self, forKey: .photosURLsDTO)
        self.likes = try? container?.decodeIfPresent(Int.self, forKey: .likes)
        self.likedByUser = (try? container?.decodeIfPresent(Bool.self, forKey: .likedByUser)) ?? false
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try? container.encodeIfPresent(self.id, forKey: .id)
        try? container.encodeIfPresent(self.description, forKey: .description)
        try? container.encodeIfPresent(self.photosURLsDTO, forKey: .photosURLsDTO)
        try? container.encodeIfPresent(self.likes, forKey: .likes)
        try? container.encodeIfPresent(self.likedByUser, forKey: .likedByUser)
    }
}
