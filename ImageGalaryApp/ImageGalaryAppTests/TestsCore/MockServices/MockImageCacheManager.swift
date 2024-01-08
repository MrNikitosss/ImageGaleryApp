//
//  MockImageCacheManager.swift
//  ImageGalaryAppTests
//
//  Created by Nikita Moskalenko on 8.01.24.
//

import Foundation
import AlamofireImage
@testable import ImageGalaryApp

final class MockImageCacheManager: ImageCacheManagerProtocol {

    private var localCache: [String : Image] = [:]

    func addToCache(image: AlamofireImage.Image, id: String) {
        self.localCache[id] = image
    }
    
    func getFromCache(id: String) -> AlamofireImage.Image? {
        self.localCache[id]
    }
    
    func cleanCache() {
        self.localCache.removeAll()
    }

}
