//
//  PhotoImageDTOMapper.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 4.01.24.
//

import Foundation

struct PhotosImagesDTOsMapper: BaseDataMapper {

    func map(object: Any) throws -> [PhotoImageDTO] {
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


struct PhotoImageDTOMapper: BaseDataMapper {

    func map(object: Any) throws -> PhotoImageDTO {
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
