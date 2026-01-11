import Foundation

struct FuturesPrice: Codable, Identifiable {
    let id: String
    let name: String
    let price: Double
    let change: Double
    let changePercent: Double
    let lastUpdated: Date

    var isPositive: Bool {
        change >= 0
    }

    var formattedPrice: String {
        String(format: "$%.2f", price)
    }

    var formattedChange: String {
        let sign = change >= 0 ? "+" : ""
        return String(format: "%@%.2f", sign, change)
    }

    var formattedChangePercent: String {
        let sign = changePercent >= 0 ? "+" : ""
        return String(format: "%@%.1f%%", sign, changePercent)
    }

    var emoji: String {
        switch id {
        case "CL=F": return "oil"
        case "ZC=F": return "corn"
        case "ZW=F": return "wheat"
        default: return "chart"
        }
    }

    static let symbols = ["CL=F", "ZC=F", "ZW=F"]

    static let displayNames: [String: String] = [
        "CL=F": "Crude Oil",
        "ZC=F": "Corn",
        "ZW=F": "Wheat"
    ]

    static func placeholder() -> [FuturesPrice] {
        [
            FuturesPrice(id: "CL=F", name: "Crude Oil", price: 72.45, change: 1.23, changePercent: 1.73, lastUpdated: Date()),
            FuturesPrice(id: "ZC=F", name: "Corn", price: 4.52, change: -0.08, changePercent: -1.74, lastUpdated: Date()),
            FuturesPrice(id: "ZW=F", name: "Wheat", price: 5.89, change: 0.12, changePercent: 2.08, lastUpdated: Date())
        ]
    }
}
