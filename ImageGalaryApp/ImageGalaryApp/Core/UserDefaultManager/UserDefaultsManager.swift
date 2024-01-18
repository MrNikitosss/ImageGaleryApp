import Foundation

struct UserDefaultsKeys: RawRepresentable {
    var rawValue: String

    static let isFavorite = UserDefaultsKeys(rawValue: "")
}

protocol UserDefaultsManagerProtocol {
    func setObject<Object>(_ object: Object, for key: UserDefaultsKeys) where Object: Encodable
    func getObject<Object>(for key: UserDefaultsKeys, castTo type: Object.Type) -> Object? where Object: Decodable
}

final class UserDefaultsManager {
    private var storage: UserDefaults

    init(storage: UserDefaults) {
        self.storage = storage

    }
}

// MARK: ObjectSavable
extension UserDefaultsManager: UserDefaultsManagerProtocol {
    func setObject<Object>(_ object: Object, for key: UserDefaultsKeys) where Object: Encodable {
        let data = try? JSONEncoder().encode(object)

        storage.set(data, forKey: key.rawValue)
    }

    func getObject<Object>(for key: UserDefaultsKeys, castTo type: Object.Type) -> Object? where Object: Decodable {
        guard let data = storage.data(forKey: key.rawValue) else {
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

