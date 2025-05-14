//
//  UserSingleton.swift
//  SnapChat Clone
//
//  Created by XECE on 13.05.2025.
//
import Foundation

class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    private init() { }
}

