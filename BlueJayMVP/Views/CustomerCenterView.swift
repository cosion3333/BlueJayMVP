//
//  CustomerCenterView.swift
//  BlueJayMVP
//
//  Customer Center for subscription management
//

import SwiftUI
import RevenueCat
import RevenueCatUI

struct CustomerCenterView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(RevenueCatService.self) private var revenueCat
    
    var body: some View {
        NavigationStack {
            CustomerCenterView()
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
    CustomerCenterView()
        .environment(RevenueCatService.shared)
}
