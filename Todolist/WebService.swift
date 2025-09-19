import Foundation

protocol WebServicing {
    func downloadData<T: Decodable>(
        fromURL: String,
        headers: [String: String]?,
        configureDecoder: ((JSONDecoder) -> Void)?
    ) async throws -> T
}

class WebService: WebServicing {
    func downloadData<T: Decodable>(
        fromURL: String,
        headers: [String: String]? = nil,
        configureDecoder: ((JSONDecoder) -> Void)? = nil
    ) async throws -> T {
        guard let url = URL(string: fromURL) else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
        guard (200..<300).contains(response.statusCode) else { throw NetworkError.badStatus }
        
        let decoder = JSONDecoder()
        configureDecoder?(decoder)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.failedToDecodeResponse
        }
    }
}
