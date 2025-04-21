//
//  Operation.swift
//  MerulaCompanion
//
//  Created by Lukas Mauffré on 21/04/2025.
//

import Foundation

enum DeviceType: String, CaseIterable, Identifiable {
    case A9 = "A9(X)"
    case A10 = "A10(X)"
    var id: String { rawValue }
}

enum Operation: String, CaseIterable, Identifiable {
    case getSHC = "Get SHC block"
    case getPTE = "Get PTE block"
    case restore = "Restore"
    case boot = "Boot"
    
    var id: String { rawValue }
    
    var requiresSHC: Bool {
        self == .getPTE || self == .restore || self == .boot
    }
    var requiresPTE: Bool {
        self == .restore || self == .boot
    }
    var requiresBlob: Bool {
        self == .restore
    }
    
    func buildArguments(device: DeviceType,
                        ipsw: String,
                        shc: String,
                        pte: String,
                        blob: String) -> [String]
    {
        switch self {
        case .getSHC:
            return ["--get-shcblock", ipsw]
        case .getPTE:
            return ["--get-pteblock", "--load-shcblock", shc, ipsw]
        case .restore:
            if device == .A9 {
                return ["-w", "--load-shsh", blob, "--load-shcblock", shc, ipsw]
            } else {
                return ["-o", ipsw]
            }
        case .boot:
            if device == .A9 {
                return ["-TP", pte]
            } else {
                return ["-t", pte]
            }
        }
    }
}
