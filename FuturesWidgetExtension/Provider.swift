import WidgetKit
import SwiftUI

struct FuturesEntry: TimelineEntry {
    let date: Date
    let prices: [FuturesPrice]
    let isPlaceholder: Bool

    static func placeholder() -> FuturesEntry {
        FuturesEntry(
            date: Date(),
            prices: FuturesPrice.placeholder(),
            isPlaceholder: true
        )
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> FuturesEntry {
        FuturesEntry.placeholder()
    }

    func getSnapshot(in context: Context, completion: @escaping (FuturesEntry) -> Void) {
        if context.isPreview {
            completion(FuturesEntry.placeholder())
            return
        }

        Task {
            do {
                let prices = try await YahooFinanceService.shared.fetchFuturesPrices()
                let entry = FuturesEntry(date: Date(), prices: prices, isPlaceholder: false)
                completion(entry)
            } catch {
                completion(FuturesEntry.placeholder())
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<FuturesEntry>) -> Void) {
        Task {
            do {
                let prices = try await YahooFinanceService.shared.fetchFuturesPrices()
                let entry = FuturesEntry(date: Date(), prices: prices, isPlaceholder: false)

                // Refresh every 5 minutes
                let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                // On error, use placeholder and retry in 1 minute
                let entry = FuturesEntry.placeholder()
                let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            }
        }
    }
}
