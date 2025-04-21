//
//  AuthorizationHelper.swift
//  MerulaCompanion
//
//  Created by Lukas Mauffré on 21/04/2025.
//

import Foundation
import Security

struct AuthorizationHelper {
    static func requestPrivilegesIfNeeded() {
        var authRef: AuthorizationRef?
        let status = AuthorizationCreate(nil, nil,
                                         [.extendRights, .interactionAllowed],
                                         &authRef)
        guard status == errAuthorizationSuccess, let auth = authRef else {
            return
        }
        
        // Utilisation de la constante C kAuthorizationRightExecute,
        // et d'un buffer temporaire pour la durée de l'appel
        let rightName = kAuthorizationRightExecute
        let item = AuthorizationItem(
            name: rightName,
            valueLength: 0,
            value: nil,
            flags: 0
        )
        var items = [item]
        items.withUnsafeMutableBufferPointer { buffer in
            var rights = AuthorizationRights(
                count: UInt32(buffer.count),
                items: buffer.baseAddress
            )
            AuthorizationCopyRights(
                auth,
                &rights,
                nil,
                [.preAuthorize, .extendRights],
                nil
            )
        }
        // authRef sera libéré automatiquement
    }
}
