//
//  RevenueCatService.swift
//  BlueJayMVP
//
//  RevenueCat integration service
//

import Foundation
import RevenueCat

/// Service for managing RevenueCat subscriptions and entitlements
@Observable
class RevenueCatService: NSObject {
    // MARK: - Singleton
    static let shared = RevenueCatService()
    
    // MARK: - Configuration
    // Production API key from RevenueCat dashboard (Blue Jay Swaps - App Store)
    private let apiKey = "appl_ioydwLPhnHRWhYBhNZDXMQCCPSy"
    private let entitlementID = "Blue Jay Swaps Pro"
    
    // MARK: - State
    var isPremium: Bool = false
    var customerInfo: CustomerInfo?
    var offerings: Offerings?
    var isLoading: Bool = false
    
    // MARK: - Private Init (Singleton)
    private override init() {
        super.init()
    }
    
    // MARK: - Configuration
    
    /// Configure RevenueCat SDK - Call this at app launch
    func configure() {
        // Configure SDK with your API key
        Purchases.logLevel = .info
        Purchases.configure(withAPIKey: apiKey)
        
        // Set up delegate for real-time updates
        Purchases.shared.delegate = self
        
        #if DEBUG
        print("✅ RevenueCat configured with API key")
        #endif
        
        // Load initial state
        Task {
            await refreshCustomerInfo()
            await loadOfferings()
        }
    }
    
    // MARK: - Customer Info
    
    /// Refresh customer info and update premium status
    @MainActor
    func refreshCustomerInfo() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let info = try await Purchases.shared.customerInfo()
            self.customerInfo = info
            self.isPremium = info.entitlements[entitlementID]?.isActive == true
            
            #if DEBUG
            print("✅ Customer info refreshed - Premium: \(isPremium)")
            #endif
        } catch {
            #if DEBUG
            print("❌ Error fetching customer info: \(error.localizedDescription)")
            #endif
        }
    }
    
    /// Sync customer info (lightweight check)
    func syncCustomerInfo() {
        Task {
            await refreshCustomerInfo()
        }
    }
    
    // MARK: - Offerings
    
    /// Load available offerings (products/packages)
    @MainActor
    func loadOfferings() async {
        do {
            let offerings = try await Purchases.shared.offerings()
            self.offerings = offerings
            
            #if DEBUG
            if let current = offerings.current {
                print("✅ Offerings loaded - Current: \(current.identifier)")
                print("   Packages: \(current.availablePackages.map { $0.identifier }.joined(separator: ", "))")
            } else {
                print("⚠️ No current offering found")
            }
            #endif
        } catch {
            #if DEBUG
            print("❌ Error loading offerings: \(error.localizedDescription)")
            #endif
        }
    }
    
    // MARK: - Purchases
    
    /// Purchase a package
    @MainActor
    func purchase(package: Package) async throws -> CustomerInfo {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await Purchases.shared.purchase(package: package)
            self.customerInfo = result.customerInfo
            self.isPremium = result.customerInfo.entitlements[entitlementID]?.isActive == true
            
            #if DEBUG
            print("✅ Purchase successful - Premium: \(isPremium)")
            #endif
            return result.customerInfo
        } catch {
            #if DEBUG
            print("❌ Purchase failed: \(error.localizedDescription)")
            #endif
            throw error
        }
    }
    
    /// Restore purchases
    @MainActor
    func restorePurchases() async throws -> CustomerInfo {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let info = try await Purchases.shared.restorePurchases()
            self.customerInfo = info
            self.isPremium = info.entitlements[entitlementID]?.isActive == true
            
            #if DEBUG
            print("✅ Purchases restored - Premium: \(isPremium)")
            #endif
            return info
        } catch {
            #if DEBUG
            print("❌ Restore failed: \(error.localizedDescription)")
            #endif
            throw error
        }
    }
    
    // MARK: - Customer Center (Manage Subscription)
    
    /// Check if customer center is available
    var canShowCustomerCenter: Bool {
        return isPremium
    }
    
    // MARK: - Helpers
    
    /// Get monthly package
    var monthlyPackage: Package? {
        return offerings?.current?.monthly
    }
    
    /// Get annual package
    var annualPackage: Package? {
        return offerings?.current?.annual
    }
    
    /// Get all available packages
    var availablePackages: [Package] {
        return offerings?.current?.availablePackages ?? []
    }
}

// MARK: - PurchasesDelegate

extension RevenueCatService: PurchasesDelegate {
    /// Called when customer info is updated (real-time entitlement changes)
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        Task { @MainActor in
            self.customerInfo = customerInfo
            self.isPremium = customerInfo.entitlements[entitlementID]?.isActive == true
            #if DEBUG
            print("🔄 Customer info updated - Premium: \(isPremium)")
            #endif
        }
    }
}
