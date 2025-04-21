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
        let rights = AuthorizationItem(name: kAuthorizationRightExecute,
                                       valueLength: 0,
                                       value: nil,
                                       flags: 0)
        var rightsSet = AuthorizationRights(count: 1, items: UnsafeMutablePointer(mutating: [rights]))
        AuthorizationCopyRights(auth,
                                &rightsSet,
                                nil,
                                [.preAuthorize, .extendRights],
                                nil)
        // authRef sera libéré automatiquement à la fin du scope
    }
}
