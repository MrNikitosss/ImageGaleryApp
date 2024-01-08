//
//  ImageCacheManager.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 4.01.24.
//

import Foundation
import AlamofireImage

protocol ImageCacheManagerProtocol {

    func addToCache(image: Image, id: String)
    func getFromCache(id: String) -> Image?
    func cleanCache()
}

final class ImageCacheManager: ImageCacheManagerProtocol {

    let cache = AutoPurgingImageCache()

    func addToCache(image: Image, id: String) {
        self.cache.add(image, withIdentifier: id)
    }

    func getFromCache(id: String) -> Image? {
        self.cache.image(withIdentifier: id)
    }

    func cleanCache() {
        self.cache.removeAllImages()
    }
}
