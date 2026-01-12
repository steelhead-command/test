import Foundation

class YahooFinanceService {
    static let shared = YahooFinanceService()

    private let baseURL = "https://query2.finance.yahoo.com/v8/finance/chart"

    private init() {}

    func fetchFuturesPrices() async throws -> [FuturesPrice] {
        let symbols = FuturesPrice.symbols

        return try await withThrowingTaskGroup(of: FuturesPrice?.self) { group in
            for symbol in symbols {
                group.addTask {
                    try await self.fetchPrice(for: symbol)
                }
            }

            var prices: [FuturesPrice] = []
            for try await price in group {
                if let price = price {
                    prices.append(price)
                }
            }

            // Sort by symbol order
            return prices.sorted { first, second in
                let firstIndex = symbols.firstIndex(of: first.id) ?? 0
                let secondIndex = symbols.firstIndex(of: second.id) ?? 0
                return firstIndex < secondIndex
            }
        }
    }

    private func fetchPrice(for symbol: String) async throws -> FuturesPrice? {
        let encodedSymbol = symbol.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? symbol
        guard let url = URL(string: "\(baseURL)/\(encodedSymbol)?interval=1d&range=1d") else {
            return nil
        }

        var request = URLRequest(url: url)
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36", forHTTPHeaderField: "User-Agent")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw YahooFinanceError.invalidResponse
        }

        let decoder = JSONDecoder()
        let chartResponse = try decoder.decode(ChartResponse.self, from: data)

        guard let result = chartResponse.chart?.result?.first,
              let meta = result.meta,
              let price = meta.regularMarketPrice,
              let previousClose = meta.chartPreviousClose else {
            return nil
        }

        let change = price - previousClose
        let changePercent = previousClose > 0 ? (change / previousClose) * 100 : 0
        let name = FuturesPrice.displayNames[symbol] ?? meta.shortName ?? symbol

        return FuturesPrice(
            id: symbol,
            name: name,
            price: price,
            change: change,
            changePercent: changePercent,
            lastUpdated: Date()
        )
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

// MARK: - Yahoo Finance Chart Response Models

struct ChartResponse: Codable {
    let chart: ChartData?
}

struct ChartData: Codable {
    let result: [ChartResult]?
    let error: ChartError?
}

struct ChartResult: Codable {
    let meta: ChartMeta?
}

struct ChartMeta: Codable {
    let symbol: String?
    let shortName: String?
    let regularMarketPrice: Double?
    let chartPreviousClose: Double?
}

struct ChartError: Codable {
    let code: String?
    let description: String?
}
