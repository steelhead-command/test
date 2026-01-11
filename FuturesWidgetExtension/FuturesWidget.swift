import WidgetKit
import SwiftUI

struct FuturesWidget: Widget {
    let kind: String = "FuturesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MediumWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Futures Prices")
        .description("Track corn, wheat, and oil futures prices.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    FuturesWidget()
} timeline: {
    FuturesEntry.placeholder()
}
