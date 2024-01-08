import Foundation

final class NetworkError {
    var errorMessage: String
    var errorCode: Int

    init(message: String, code: Int) {
        errorMessage = message
        errorCode = code
    }

    init(error: String) {
        errorMessage = error
        errorCode = 0
    }

    init(error: NSError) {
        errorMessage = error.localizedDescription
        errorCode = error.code
    }

    init(error: Error) {
        errorMessage = error.localizedDescription
        errorCode = 0
    }

    init(error: NSDictionary) {
        if let message = error["message"] as? String  {
            errorMessage = message
            errorCode = 0

        } else {
            errorMessage = "Unknown error type"
            errorCode = 0
        }
    }
}

extension NetworkError: Error {}

extension NetworkError: LocalizedError {

    var errorDescription: String? {
        return self.errorMessage
    }
}
