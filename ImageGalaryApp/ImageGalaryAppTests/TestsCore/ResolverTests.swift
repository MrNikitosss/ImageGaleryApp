//
//  ResolverTests.swift
//  ImageGalaryAppTests
//
//  Created by Nikita Moskalenko on 8.01.24.
//

import Foundation
import Resolver
@testable import ImageGalaryApp

extension Resolver {
    static var mock = Resolver(child: .main)

    static func registerMockServices() {
        root = Resolver.mock
        defaultScope = .application
        Resolver.mock.register { MockNetWorkManager() }.implements(NetworkServiceProtocol.self) 
        Resolver.mock.register { MockUserDefaultsService() }.implements(UserDefaultsManagerProtocol.self)
        Resolver.mock.register { MockImageCacheManager() }.implements(ImageCacheManagerProtocol.self )
        Resolver.mock.register { MockImageLoaderService() }.implements(ImageLoaderManagerProtocol.self )
    }
}
