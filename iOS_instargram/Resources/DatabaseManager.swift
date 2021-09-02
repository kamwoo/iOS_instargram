//
//  DatabaseManager.swift
//  iOS_instargram
//
//  Created by wooyeong kam on 2021/08/03.
//

import Foundation
import FirebaseDatabase

public class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    
    // check username, email, password is available
    public func canCreateNewUser(with email: String, username: String, completion: (Bool) -> Void){
        completion(true)
    }
    
    public func insertNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void){
        database.child(email.safeDatabaseKey()).setValue(["username":username]) { error, _ in
            if error != nil {
                // succeeded
                completion(true)
                return
            }
            else {
                completion(false)
                print("DatabaseManager - insertNewUser() error")
                return
            }
        }
    }
    
}
