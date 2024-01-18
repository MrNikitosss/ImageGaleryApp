//
//  MockUserDefaultsService.swift
//  ImageGalaryAppTests
//
//  Created by Nikita Moskalenko on 8.01.24.
//

import Foundation
@testable import ImageGalaryApp

final class MockUserDefaultsService: UserDefaultsManagerProtocol {

    private var localStorage: [String : Any] = [:]

    func setObject<Object>(_ object: Object, for key: UserDefaultsKeys) where Object : Encodable {
        self.localStorage[key.rawValue] = object
    }

    func getObject<Object>(for key: UserDefaultsKeys, castTo type: Object.Type) -> Object? where Object : Decodable {
        return self.localStorage[key.rawValue] as? Object
    }

}
