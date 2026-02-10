//
//  ObservabilityService.swift
//  BlueJayMVP
//
//  Lightweight production diagnostics and event tracing.
//

import Foundation
import OSLog

enum AppEvent: String, Codable {
    case recallCompleted = "recall_completed"
    case swapUsedConfirmed = "swap_used_confirmed"
    case focusFoodSet = "focus_food_set"
    case paywallShown = "paywall_shown"
    case subscriptionStarted = "subscription_started"
    case appCrash = "app_crash"
}

struct EventLogEntry: Codable {
    let event: AppEvent
    let timestamp: Date
    let metadata: [String: String]
}

struct ObservabilityService {
    private static let logger = Logger(subsystem: "Orion.BlueJayMVP", category: "analytics")
    private static let defaults = UserDefaults.standard
    private static let eventLogKey = "event_log_entries"
    private static let maxEntries = 200
    
    static func configure() {
        NSSetUncaughtExceptionHandler(blueJayUncaughtExceptionHandler)
    }
    
    static func track(_ event: AppEvent, metadata: [String: String] = [:]) {
        logger.info("event=\(event.rawValue, privacy: .public) metadata=\(metadata, privacy: .public)")
        
        var entries = loadEvents()
        entries.append(EventLogEntry(event: event, timestamp: Date(), metadata: metadata))
        
        if entries.count > maxEntries {
            entries.removeFirst(entries.count - maxEntries)
        }
        
        if let encoded = try? JSONEncoder().encode(entries) {
            defaults.set(encoded, forKey: eventLogKey)
        }
    }
    
    static func loadEvents() -> [EventLogEntry] {
        guard let data = defaults.data(forKey: eventLogKey),
              let entries = try? JSONDecoder().decode([EventLogEntry].self, from: data) else {
            return []
        }
        return entries
    }
    
    static func handleUncaughtException(_ exception: NSException) {
        track(
            .appCrash,
            metadata: [
                "uncaught_exception": exception.name.rawValue,
                "reason": exception.reason ?? "unknown"
            ]
        )
    }
}

private func blueJayUncaughtExceptionHandler(_ exception: NSException) {
    ObservabilityService.handleUncaughtException(exception)
}
