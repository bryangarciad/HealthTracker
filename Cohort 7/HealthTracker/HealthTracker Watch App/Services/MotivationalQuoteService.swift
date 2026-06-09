import Foundation
import Combine

class MotivationalQuoteService {
    // Singleton
    static let shared = MotivationalQuoteService()
    private init() {}
    
    // MARK: - API Config
    private let apiURL: String = "https://zenquotes.io/api/random"
    
    private let fallbackQuotes: [MotivationalQuote] = [
        MotivationalQuote(quote: "Every step counts towards your goal!", author: "Health Wisdom"),
        MotivationalQuote(quote: "Hydration is the foundation of health.", author: "Wellness Guide"),
        MotivationalQuote(quote: "Small progress is still progress.", author: "Daily Motivation"),
        MotivationalQuote(quote: "Your body deserves the best fuel.", author: "Nutrition Tip"),
        MotivationalQuote(quote: "Consistency beats perfection.", author: "Fitness Coach"),
        MotivationalQuote(quote: "Listen to your body, it knows.", author: "Health Wisdom"),
        MotivationalQuote(quote: "One glass at a time builds oceans.", author: "Hydration Tip"),
        MotivationalQuote(quote: "Energy comes from what you consume.", author: "Nutrition Guide")
    ]
    
    
    func fetchQuote() async -> MotivationalQuote {
        guard let url = URL(string: apiURL) else {
            return getRandomeQuoteFromFallback()
        }
        
        do {
            let (rawData, _) = try await URLSession.shared.data(from: url)
            
            let data = try JSONDecoder().decode([MotivationalQuote.APIResponse].self, from: rawData)
            
            if let data = data.first {
                return MotivationalQuote(quote: data.q, author: data.a)
            }
        } catch {
            print("API ERROR: \(error.localizedDescription)")
        }
        
        return getRandomeQuoteFromFallback()
    }
    
    func getRandomeQuoteFromFallback() -> MotivationalQuote {
        fallbackQuotes.randomElement() ?? fallbackQuotes[0]
    }
}
