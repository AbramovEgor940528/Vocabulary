
enum NetworkServiceError: Error {
    case decodingFailed
    case badURL
    case noData
    case badResponse
    
    var errorDescription: String {
        switch self {
        case .decodingFailed:
            return "Декодирование не удалось"
        case .badURL:
            return "не верный URL"
        case .noData:
             return "нет данных"
        case .badResponse:
             return "Неизвестная ошибка"
        }
    }
}
