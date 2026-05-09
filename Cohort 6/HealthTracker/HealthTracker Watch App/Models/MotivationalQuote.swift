import Foundation
import Combine

struct MotivationalQuote: Codable {
    let quote: String
    let author: String
    
    // Actual API Response from ZenQuotes
    struct APIResponse: Codable {
        let q: String
        let a: String
    }
    
    static func from(apiResponse: MotivationalQuote.APIResponse) -> MotivationalQuote {
        return MotivationalQuote(
            quote: quote.q, author: quote.a
        )
    }
}
