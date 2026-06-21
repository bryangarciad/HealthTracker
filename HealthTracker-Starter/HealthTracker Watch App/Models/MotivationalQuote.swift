//
//  MotivationalQuote.swift
//  HealthTracker Watch App
//
//  A small model for the motivational quote we show after the user logs
//  something. It also knows how to decode the exact shape of JSON returned
//  by the free ZenQuotes API.
//

import Foundation

struct MotivationalQuote: Codable {
    let quote: String
    let author: String

    // MARK: - APIResponse
    //
    // The ZenQuotes API returns JSON that looks like this:
    //     [ { "q": "Some quote", "a": "Some author" } ]
    //
    // Its field names ("q" and "a") don't match our nice names ("quote" and
    // "author"), so we make a separate small struct whose property names match
    // the JSON EXACTLY. We decode into this, then copy the values into a clean
    // MotivationalQuote. (See MotivationalQuoteService.swift.)
    struct APIResponse: Codable {
        let q: String   // the quote text
        let a: String   // the author
    }
}
