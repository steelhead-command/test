import Foundation

class YahooFinanceService {
    static let shared = YahooFinanceService()

    private let baseURL = "https://query1.finance.yahoo.com/v7/finance/quote"
    private let symbols = FuturesPrice.symbols.joined(separator: ",")

    private init() {}

    func fetchFuturesPrices() async throws -> [FuturesPrice] {
        guard let url = URL(string: "\(baseURL)?symbols=\(symbols)") else {
            throw YahooFinanceError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw YahooFinanceError.invalidResponse
        }

        let decoder = JSONDecoder()
        let yahooResponse = try decoder.decode(YahooFinanceResponse.self, from: data)

        guard let results = yahooResponse.quoteResponse?.result else {
            throw YahooFinanceError.noData
        }

        let now = Date()
        return results.compactMap { quote -> FuturesPrice? in
            guard let symbol = quote.symbol,
                  let price = quote.regularMarketPrice,
                  let change = quote.regularMarketChange,
                  let changePercent = quote.regularMarketChangePercent else {
                return nil
            }

            let name = FuturesPrice.displayNames[symbol] ?? quote.shortName ?? symbol

            return FuturesPrice(
                id: symbol,
                name: name,
                price: price,
                change: change,
                changePercent: changePercent,
                lastUpdated: now
            )
        }
    }
}

enum YahooFinanceError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .noData:
            return "No data available"
        }
    }
}

// MARK: - Yahoo Finance Response Models

struct YahooFinanceResponse: Codable {
    let quoteResponse: QuoteResponse?
}

struct QuoteResponse: Codable {
    let result: [QuoteResult]?
}

struct QuoteResult: Codable {
    let symbol: String?
    let shortName: String?
    let regularMarketPrice: Double?
    let regularMarketChange: Double?
    let regularMarketChangePercent: Double?
}
