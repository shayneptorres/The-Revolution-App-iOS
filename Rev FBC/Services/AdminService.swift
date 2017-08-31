//
//  AdminService.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/30/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import Foundation
import KeychainAccess

class AdminService {
    
    
    let KEYCHAIN_SERVICE = "revfbc"
    
    typealias UserCredentialTuple = (email: String, pass: String)
    
    static let instance = AdminService()
    
    /// Returns a boolean representing if the user is logged in or not
    ///
    /// - Returns: boolean if user is logged in
    func isUserLoggedIn() -> Bool {
        
        return getUserCredentials() != nil
    }
    
    /// Saves the given email and password to the app keychain
    ///
    /// - Parameters:
    ///   - email: the email to be saved
    ///   - password: the password to be saved
    func saveUserCredentials(email: String, password: String) {
        let keychain = Keychain(service: KEYCHAIN_SERVICE)
        
        do {
            try keychain.set(email, key: "email")
            try keychain.set(password, key: "password")
        } catch {
            
        }
    }
    
    /// Returns a tuple with the user credentials
    ///
    /// - Returns: a tuple with the user credentials, nil if user is not logged in
    func getUserCredentials() -> UserCredentialTuple? {
        
        let keychain = Keychain(service: KEYCHAIN_SERVICE)
        
        do {
            let email = try keychain.getString("email")
            let password = try keychain.getString("password")
            
            guard let e = email, let p = password else {
                return nil
            }
            
            let credentials : UserCredentialTuple = (email: e, pass: p)
            
            return credentials
            
        } catch {
            print("ERROR: Could not retrieve user credentials from keychain")
        }
        
        return nil
    }
    
    /// Resets all the user credentials stored in the keychain
    func resetUserCredentials(){
        let keychain = Keychain(service: "revfbc")
        
        do {
            try keychain.removeAll()
        } catch {
        }
    }
    
}
