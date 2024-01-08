import Foundation

enum UserDefaultsKeys: String {
    case isFavorite
}

protocol UserDefaultsManagerProtocol {
    func setObject<Object>(_ object: Object, for key: String) where Object: Encodable
    func getObject<Object>(for key: String, castTo type: Object.Type) -> Object? where Object: Decodable
}

final class UserDefaultsManager: NSObject {
    private var storage: UserDefaults

    init(storage: UserDefaults) {
        self.storage = storage
    }
}

// MARK: ObjectSavable
extension UserDefaultsManager: UserDefaultsManagerProtocol {
    func setObject<Object>(_ object: Object, for key: String) where Object: Encodable {
        let data = try? JSONEncoder().encode(object)

        storage.set(data, forKey: key)
    }

    func getObject<Object>(for key: String, castTo type: Object.Type) -> Object? where Object: Decodable {
        guard let data = storage.data(forKey: key) else {
            return nil
        }

        return try? JSONDecoder().decode(type, from: data)
    }
}

// MARK: Subscript
extension UserDefaults {
    subscript<T: Codable>(dataKey: String) -> T? {
        get {
            guard let data = object(forKey: dataKey) as? Data else {
                return nil
            }

            return try? JSONDecoder().decode(T.self, from: data)
        }

        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                return
            }

            set(data, forKey: dataKey)
        }
    }
}

