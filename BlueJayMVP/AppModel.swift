//
//  AppModel.swift
//  BlueJayMVP
//
//  Created by Cosmin Ionescu on 11/25/25.
//

import Foundation

enum TargetFood: String, CaseIterable {
    case fries = "Fries"
    case soda = "Soda"
    case chips = "Chips"
}

struct SwapCombo: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let estKcalDrop: Int
}

