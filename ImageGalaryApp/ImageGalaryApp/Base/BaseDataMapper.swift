//
//  BaseDataMapper.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 3.01.24.
//

import Foundation
import RxSwift

class BaseDataMapper<T, U> {
    func map(object: T) throws -> U {
        fatalError("function map should be overrided!")
    }
}

extension PrimitiveSequence where Trait == SingleTrait {

    func map<U>(with dataMapper: BaseDataMapper<Element, U>) -> Single<U> {
        return self.flatMap { (element) -> Single<U> in
            do {
                let object = try dataMapper.map(object: element)
                return Single.just(object)
            } catch {
                return Single.error(error)
            }
        }
    }

    func map<U>(with dataMapper: @escaping ((Element) throws -> U)) -> Single<U> {
        return self.flatMap { (element) -> Single<U> in
            do {
                let object = try dataMapper(element)
                return Single.just(object)
            } catch {
                return Single.error(error)
            }
        }
    }

}
