//
//  ImageLoaderManager.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 4.01.24.
//

import Foundation
import Alamofire
import AlamofireImage

protocol ImageLoaderManagerProtocol: AnyObject {
    func loadImageFrom(
        imageURL: String,
        onSuccess: @escaping ((Image) -> Void),
        onFailure: @escaping ((NetworkError) -> Void)
    )

    func cancelAnyRequest()
}

final class ImageLoaderManager: ImageLoaderManagerProtocol {

    private var anyRequest: DataRequest?

    func loadImageFrom(
        imageURL: String,
        onSuccess: @escaping ((Image) -> Void),
        onFailure: @escaping ((NetworkError) -> Void)
    ) {
        self.anyRequest = AF.request(imageURL)
        self.anyRequest?.responseImage(queue: .global(qos: .userInteractive)) { dataresponse in

                switch dataresponse.result {

                case .success(let image):
                    onSuccess(image)
                case .failure(let failure):
                    onFailure(NetworkError(error: failure.localizedDescription))
                }
            }
    }

    func cancelAnyRequest() {
        self.anyRequest?.cancel()
    }
}
