//
//  AuthManager.swift
//  iOS_instargram
//
//  Created by wooyeong kam on 2021/08/03.
//

import Foundation
import FirebaseAuth

public class AuthManager {
    static let shared = AuthManager()
    
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void){
        // 사용가능한 이메일, 아이디인지 확인
        DatabaseManager.shared.canCreateNewUser(with: email, username: username){ canCreate in
            if canCreate {
                Auth.auth().createUser(withEmail: email, password: password){ result, error in
                    guard error == nil, result != nil else {
                        completion(false)
                        print("AuthManager-createUser() error")
                        return
                    }
                    
                    DatabaseManager.shared.insertNewUser(with: email, username: username){ success in
                        if success {
                            completion(true)
                            return
                        }
                        else {
                            completion(false)
                            return
                        }
                    }
                }
            }
            else{
                completion(false)
            }
            
        }
    }
    
    public func loginUser(username: String?, email: String?, password: String, completion: @escaping ((Bool) -> Void)){
        if let email = email{
            Auth.auth().signIn(withEmail: email, password: password){ authResult, error in
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
        else if let username = username {
            print(username)
        }
    }
    
    public func logOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch {
            print("error")
            completion(false)
            return
        }
    }
}
