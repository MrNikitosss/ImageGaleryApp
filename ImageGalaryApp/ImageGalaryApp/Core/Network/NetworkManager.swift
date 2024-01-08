//
//  NetworkManager.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 3.01.24.
//

import Foundation
import Alamofire
import AlamofireImage
import Resolver

enum ApiEndPoints {

    case photosList
    case likePhoto(id: String)

    func pathMaker() -> String {
        switch self {
        case .photosList:
            return ConfigurationPrivacy.base_url + "photos"
        case .likePhoto(let id):
            return ConfigurationPrivacy.base_url + "photos/\(id)/like"
        }
    }
}

protocol NetworkServiceProtocol {

    func request(
        url: ApiEndPoints,
        httpMethod: HTTPMethod,
        params: [String : Any]?,
        onSuccess: @escaping ((Any) -> Void),
        onFailure: @escaping ((NetworkError) -> Void)
    )
}

final class NetworkService: NetworkServiceProtocol {

    @Injected private var session: Session

    func request(
        url: ApiEndPoints,
        httpMethod: HTTPMethod,
        params: [String : Any]? = nil,
        onSuccess: @escaping ((Any) -> Void),
        onFailure: @escaping ((NetworkError) -> Void)
    ) {

        let request = self.session.request(
            url.pathMaker(),
            method: httpMethod,
            parameters: params
        )
            .responseData { dataResponse in
                switch dataResponse.result {

                case .success(let success):
                    onSuccess(success)
                case .failure(let failure):
                    onFailure(NetworkError(error: failure.localizedDescription))
                }
            }

        request.resume()
    }
}

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        self.defaultScope = .graph
        register { Session() }
        register { NetworkService() }.implements(NetworkServiceProtocol.self)
        register { ImageLoaderManager() }.implements(ImageLoaderManagerProtocol.self)
        register { ImageCacheManager() }.implements(ImageCacheManagerProtocol.self)
        register { UserDefaultsManager(storage: UserDefaults.standard) }.implements(UserDefaultsManagerProtocol.self)
    }
}
