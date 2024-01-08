//
//  PhotoImageDTOMapper.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 4.01.24.
//

import Foundation

final class PhotosImagesDTOsMapper: BaseDataMapper<Any, [PhotoImageDTO]> {

    override func map(object: Any) throws -> [PhotoImageDTO] {
        guard
            let jsonData = object as? Data,
            let photoImageDTO = try? JSONDecoder().decode(
                [PhotoImageDTO].self,
                from: jsonData
            )
        else {
            let error = NetworkError(error: "PhotoImageDTO mapping failed")
            throw error
        }

        return photoImageDTO
    }
}


final class PhotoImageDTOMapper: BaseDataMapper<Any, PhotoImageDTO> {

    override func map(object: Any) throws -> PhotoImageDTO {
        guard
            let jsonData = object as? Data,
            let photoImageDTO = try? JSONDecoder().decode(
                PhotoImageDTO.self,
                from: jsonData
            )
        else {
            let error = NetworkError(error: "PhotoImageDTO mapping failed")
            throw error
        }

        return photoImageDTO
    }
}
