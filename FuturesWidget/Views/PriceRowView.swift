import SwiftUI

struct PriceRowView: View {
    let price: FuturesPrice

    var body: some View {
        HStack {
            // Commodity icon
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 40)

            // Name
            VStack(alignment: .leading, spacing: 2) {
                Text(price.name)
                    .font(.headline)
                Text(price.id)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Price and change
            VStack(alignment: .trailing, spacing: 2) {
                Text(price.formattedPrice)
                    .font(.headline)
                    .monospacedDigit()

                HStack(spacing: 4) {
                    Text(price.formattedChange)
                    Text(price.formattedChangePercent)
                }
                .font(.caption)
                .foregroundColor(price.isPositive ? .green : .red)
            }
        }
        .padding(.vertical, 4)
    }

    private var iconName: String {
        switch price.id {
        case "CL=F": return "drop.fill"
        case "ZC=F": return "leaf.fill"
        case "ZW=F": return "sparkles"
        default: return "chart.line.uptrend.xyaxis"
        }
    }
}

#Preview {
    List {
        PriceRowView(price: FuturesPrice(
            id: "CL=F",
            name: "Crude Oil",
            price: 72.45,
            change: 1.23,
            changePercent: 1.73,
            lastUpdated: Date()
        ))
        PriceRowView(price: FuturesPrice(
            id: "ZC=F",
            name: "Corn",
            price: 4.52,
            change: -0.08,
            changePercent: -1.74,
            lastUpdated: Date()
        ))
    }
}
