import Foundation

enum NamingStyle {
    case underscore
}

class NamingConvention {
    static func transformName(_ name: String, style: NamingStyle) -> String {
        switch style {
        case .underscore:
            return name.replacingOccurrences(of: " ", with: "_").lowercased()
        }
    }
}
