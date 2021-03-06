//
//  SignupEntity.swift
//  ThePersonalTrainerClub
//
//  Created by David Lopez Rodriguez on 10/11/2018.
//  Copyright © 2018 eXceptionCoders. All rights reserved.
//

import Foundation

struct RegisterRequest {
    let nameKey = "name"
    let name: String
    
    let lastNameKey = "lastname"
    let lastName: String
    
    let birthdayKey = "birthday"
    let birthday: String
    
    let genderKey = "gender"
    let gender: String
    
    let emailKey = "email"
    let email: String
    
    let passwordKey = "password"
    let password: String
    
    let coachKey = "coach"
    let coach: Bool
}

struct SignupResponse: BaseResponse {
    var version: String
    var status: String
    var message: String
    var datetime: String
    var error: [String: String]?
}
