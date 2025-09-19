import Foundation
import SwiftUI

@Observable
class QuotesStore {
    enum LoadState {
        case idle
        case loading
        case success([Quote])
        case failure(Error)
    }

    private(set) var state: LoadState = .idle
    var selectedQuote: Quote?
    
    var quotes: [Quote] {
        if case .success(let quotes) = state {
            return quotes
        }
        return []
    }
    
    private let webService: WebServicing
    
    init(webService: WebServicing) {
        self.webService = webService
    }
    
    func fetchData() async {
        state = .loading
        do {
            let headers = ["X-Api-Key": "mcntcPhLAxRe0rUGhaG6uA==8Z9H74TPMpYZdbsh"]
            
            let downloadedData: [Quote] = try await webService.downloadData(
                fromURL: "https://api.api-ninjas.com/v1/quotes",
                headers: headers
            ) { decoder in
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            }
            
            state = .success(downloadedData)
        } catch {
            state = .failure(error)
        }
    }
}
