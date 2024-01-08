//
//  MockNetWorkManager.swift
//  ImageGalaryAppTests
//
//  Created by Nikita Moskalenko on 8.01.24.
//

import Alamofire
import Foundation
@testable import ImageGalaryApp

final class MockNetWorkManager: NetworkServiceProtocol {

    enum RequestResult {
        case success(data: Any)
        case failure(error: NetworkError)
    }

    var result: RequestResult = .success(data: String())

    func request(
        url: ImageGalaryApp.ApiEndPoints,
        httpMethod: Alamofire.HTTPMethod,
        params: [String : Any]?,
        onSuccess: @escaping ((Any) -> Void),
        onFailure: @escaping ((ImageGalaryApp.NetworkError) -> Void)
    ) {
        switch self.result {
        case .success(let data):
            onSuccess(data)
        case .failure(let error):
            onFailure(error)
        }
    }
    



}
