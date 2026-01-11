import SwiftUI
import WidgetKit

struct MediumWidgetView: View {
    let entry: FuturesEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Text("Futures Prices")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                if entry.isPlaceholder {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundColor(.secondary)
                }
            }

            Divider()

            // Price rows
            ForEach(entry.prices) { price in
                WidgetPriceRow(price: price)
            }

            Spacer(minLength: 0)

            // Footer with last updated time
            HStack {
                Text("Updated: \(entry.date, style: .time)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .padding()
    }
}

struct WidgetPriceRow: View {
    let price: FuturesPrice

    var body: some View {
        HStack(spacing: 8) {
            // Icon
            Image(systemName: iconName)
                .font(.subheadline)
                .foregroundColor(iconColor)
                .frame(width: 20)

            // Name
            Text(price.name)
                .font(.subheadline)
                .lineLimit(1)

            Spacer()

            // Price
            Text(price.formattedPrice)
                .font(.subheadline)
                .fontWeight(.medium)
                .monospacedDigit()

            // Change percent
            Text(price.formattedChangePercent)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(price.isPositive ? .green : .red)
                .frame(width: 50, alignment: .trailing)
        }
    }

    private var iconName: String {
        switch price.id {
        case "CL=F": return "drop.fill"
        case "ZC=F": return "leaf.fill"
        case "ZW=F": return "sparkles"
        default: return "chart.line.uptrend.xyaxis"
        }
    }

    private var iconColor: Color {
        switch price.id {
        case "CL=F": return .black
        case "ZC=F": return .yellow
        case "ZW=F": return .orange
        default: return .blue
        }
    }
}

#Preview(as: .systemMedium) {
    FuturesWidget()
} timeline: {
    FuturesEntry.placeholder()
}
