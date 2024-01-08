//
//  MoackImageLoaderService.swift
//  ImageGalaryAppTests
//
//  Created by Nikita Moskalenko on 8.01.24.
//

import Foundation
import AlamofireImage
@testable import ImageGalaryApp

final class MockImageLoaderService: ImageLoaderManagerProtocol {

    func cancelAnyRequest() { }
    

    func loadImageFrom(
        imageURL: String,
        onSuccess: @escaping ((AlamofireImage.Image) -> Void),
        onFailure: @escaping ((ImageGalaryApp.NetworkError) -> Void)
    ) {
    }
    

}
