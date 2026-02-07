//
//  CustomerCenterView.swift
//  BlueJayMVP
//
//  Customer Center for subscription management
//

import SwiftUI
import RevenueCat
import RevenueCatUI

struct SubscriptionManagerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(RevenueCatService.self) private var revenueCat
    
    var body: some View {
        NavigationStack {
            RevenueCatUI.CustomerCenterView()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
        }
    }
}

#Preview {
    SubscriptionManagerView()
        .environment(RevenueCatService.shared)
}
