//
//  BaseDataMapper.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 3.01.24.
//

import Foundation
import RxSwift

protocol BaseDataMapper {
    associatedtype T
    associatedtype U

    func map(object: T) throws -> U
}
