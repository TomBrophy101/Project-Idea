//
//  BiometricManager.swift
//  
//
//  Created by Tom Brophy on 10/03/2026.
//
import Foundation
import LocalAuthentication

struct BiometricManager {

    static func authenticateUser(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Access to your secure data is required."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            print("Biometrics not available: \(error?.localizedDescription ?? "Unknown error")")
            completion(false)
        }
    }
}
