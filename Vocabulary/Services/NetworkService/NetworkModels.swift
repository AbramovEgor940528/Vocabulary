import Foundation

struct TranslationResponse: Decodable {
    let responseData: ResponseData
    let responseStatus: Int
    let responseDetails: String?
}

struct ResponseData: Decodable {
    let translatedText: String
}
