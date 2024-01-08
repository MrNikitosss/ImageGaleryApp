//
//  ConfigurationPrivacy.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 3.01.24.
//

import Foundation
public enum ConfigurationPrivacy {

    enum Keys {
        static let baseUrl = "BASE_URL"
        static let accessKey = "ACCESS_KEY"
    }

    private static let infoPlist: [String : Any] = {
        guard
            let dict = Bundle.main.infoDictionary
        else { fatalError() }

        return dict
    }()

    static let base_url: String = {
        guard
            let baseUrl = ConfigurationPrivacy.infoPlist[Keys.baseUrl] as? String
        else { fatalError() }

        return baseUrl
    }()

    static let access_token: String = {
        guard
            let accessToken = ConfigurationPrivacy.infoPlist[Keys.accessKey] as? String
        else { fatalError() }

        return accessToken
    }()
}
