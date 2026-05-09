import Foundation
import Combine

class MotivationalQuoteService {
    static let shared = MotivationalQuoteService()
    private init() {}
    
    // MARK: - Private Props
    private let apiURL: String = "https://zenquotes.io/api/random"
    
    // MARK: - Fallback Quotes
    private let lastFallbackQuotesSyncTime: Date = Date()
    private let fallbackQuotes: [MotivationalQuote] = [
        MotivationalQuote(quote: "Every step counts towards your goal!", author: "Health Wisdom"),
        MotivationalQuote(quote: "Hydration is the foundation of health.", author: "Health Wisdom")
    ]
    
    func fetchQuote() async -> MotivationalQuote {
        if fallbackQuotes.count > 0 && lastFallbackQuotesSyncTime.timeIntervalSinceNow > 60.0 {
            return fallbackQuotes.randomElement() ?? fallbackQuotes[0]
        }
        
        // Proceed to Network Retrieve
        guard let url = URL(string: apiURL) else {
            return fallbackQuotes.randomElement() ?? MotivationalQuote(quote: "Every step counts towards your goal!", author: "Health Wisdom")
        }
        
        do {
            // data here is the byte stream response not the MQ struct
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let response = try JSONDecoder().decode([MotivationalQuote.APIResponse].self, from: data)
            
            if let quote = response.first {
                return MotivationalQuote.from(apiResponse: quote)
            }
            
        } catch {
            print("API Error")
        }
        
        return fallbackQuotes.randomElement() ?? fallbackQuotes[0]
    }
}
