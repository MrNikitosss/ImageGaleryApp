//
//  PhotosImageURLsDTO.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 4.01.24.
//

import Foundation


struct PhotosImageURLsDTO {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
    let smallS3: String?
}

extension PhotosImageURLsDTO: Codable {

    enum CodingKeys: String, CodingKey {
        case raw
        case full
        case regular
        case small
        case thumb
        case smallS3 = "small_s3"
    }

    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)

        self.raw = try? container?.decodeIfPresent(String.self, forKey: .raw)
        self.full = try? container?.decodeIfPresent(String.self, forKey: .full)
        self.regular = try? container?.decodeIfPresent(String.self, forKey: .regular)
        self.small = try? container?.decodeIfPresent(String.self, forKey: .small)
        self.thumb = try? container?.decodeIfPresent(String.self, forKey: .thumb)
        self.smallS3 = try? container?.decodeIfPresent(String.self, forKey: .smallS3)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try? container.encodeIfPresent(self.raw, forKey: .raw)
        try? container.encodeIfPresent(self.full, forKey: .full)
        try? container.encodeIfPresent(self.regular, forKey: .regular)
        try? container.encodeIfPresent(self.small, forKey: .small)
        try? container.encodeIfPresent(self.thumb, forKey: .thumb)
        try? container.encodeIfPresent(self.smallS3, forKey: .smallS3)
    }
}
