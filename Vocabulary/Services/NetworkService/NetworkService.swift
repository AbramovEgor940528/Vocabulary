import Network
import Foundation

protocol NetworkServiceProtocol {
    func getTranslation(word: String, completionHandler: @escaping (Result<ResponseData, NetworkServiceError>) -> ())
}

class NetworkService: NetworkServiceProtocol {
    
    private let baseURLString =  "https://api.mymemory.translated.net/"
    
    func getTranslation(word: String, completionHandler: @escaping (Result<ResponseData, NetworkServiceError>) -> ()) {
        
        let path = "get?q=\(word)&langpair=en%7Cru"
        
        guard
            let url = URL(string: baseURLString + path)
        else {
            completionHandler(.failure(.badURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                completionHandler(.failure(.noData))
                
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, !(200..<300).contains(statusCode) {
                completionHandler(.failure(.badResponse))
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(TranslationResponse.self, from: data)
                completionHandler(.success(decodedResponse.responseData))
            } catch {
                completionHandler(.failure(.decodingFailed))
            }
            
        }.resume()
    }
}
