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
        // 1) Création de la référence d’autorisation
        var authRef: AuthorizationRef?
        let status = AuthorizationCreate(
            nil,
            nil,
            [.extendRights, .interactionAllowed],
            &authRef
        )
        guard status == errAuthorizationSuccess, let auth = authRef else { return }
        
        // 2) kAuthorizationRightExecute → C‑string vivante le temps de la closure
        kAuthorizationRightExecute.withCString { cString in
            // 3) AuthorizationItem utilisant le pointeur valide
            var authItem = AuthorizationItem(
                name: cString,
                valueLength: 0,
                value: nil,
                flags: 0
            )
            
            // 4) Pointer vers AuthorizationItem pour AuthorizationRights
            withUnsafeMutablePointer(to: &authItem) { itemPtr in
                var authRights = AuthorizationRights(count: 1, items: itemPtr)
                let flags: AuthorizationFlags = [.preAuthorize, .extendRights]
                
                // 5) Demande des privilèges √
                AuthorizationCopyRights(
                    auth,
                    &authRights,
                    nil,
                    flags,
                    nil
                )
            }
        }
    }
}
