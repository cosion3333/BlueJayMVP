//
//  BlueJayMVPTests.swift
//  BlueJayMVPTests
//
//  Created by Cosmin Ionescu on 9/1/25.
//

import Testing
import Foundation
@testable import BlueJayMVP

struct BlueJayMVPTests {

    @Test func swapComboUsesStableIdentifier() async throws {
        let first = SwapCombo(
            targetFoodId: "fries",
            title: "Chicken Pita Combo",
            description: "A lighter trade",
            foods: ["Chicken Pita", "Side Salad"]
        )
        let second = SwapCombo(
            targetFoodId: "fries",
            title: "Chicken Pita Combo",
            description: "Same semantic swap",
            foods: ["Chicken Pita", "Side Salad"]
        )
        
        #expect(first.id == second.id)
    }
    
    @Test func weeklyResetResetsWhenWeekChanges() async throws {
        PersistenceService.clearAllData()
        defer { PersistenceService.clearAllData() }
        
        let model = AppModel(revenueCat: .shared)
        model.swapUsesThisWeek = 4
        PersistenceService.saveSwapUsesThisWeek(4)
        
        let eightDaysAgo = Calendar.current.date(byAdding: .day, value: -8, to: Date())!
        PersistenceService.saveLastSwapResetWeekStart(eightDaysAgo)
        
        model.checkAndResetWeeklySwapUsesIfNeeded(referenceDate: Date())
        
        #expect(model.swapUsesThisWeek == 0)
        #expect(PersistenceService.loadSwapUsesThisWeek() == 0)
    }
    
    @Test func weeklyResetDoesNotResetWithinSameWeek() async throws {
        PersistenceService.clearAllData()
        defer { PersistenceService.clearAllData() }
        
        let model = AppModel(revenueCat: .shared)
        model.swapUsesThisWeek = 3
        PersistenceService.saveSwapUsesThisWeek(3)
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        PersistenceService.saveLastSwapResetWeekStart(tomorrow)
        
        model.checkAndResetWeeklySwapUsesIfNeeded(referenceDate: Date())
        
        #expect(model.swapUsesThisWeek == 3)
        #expect(PersistenceService.loadSwapUsesThisWeek() == 3)
    }

}
