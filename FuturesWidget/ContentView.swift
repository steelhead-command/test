import SwiftUI

struct ContentView: View {
    @State private var prices: [FuturesPrice] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Group {
                if isLoading && prices.isEmpty {
                    ProgressView("Loading prices...")
                } else if let error = errorMessage, prices.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(error)
                            .foregroundColor(.secondary)
                        Button("Retry") {
                            Task { await fetchPrices() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List {
                        ForEach(prices) { price in
                            PriceRowView(price: price)
                        }
                    }
                    .refreshable {
                        await fetchPrices()
                    }
                }
            }
            .navigationTitle("Futures Prices")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isLoading && !prices.isEmpty {
                        ProgressView()
                    }
                }
            }
        }
        .task {
            await fetchPrices()
        }
    }

    private func fetchPrices() async {
        isLoading = true
        errorMessage = nil

        do {
            prices = try await YahooFinanceService.shared.fetchFuturesPrices()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

#Preview {
    ContentView()
}
