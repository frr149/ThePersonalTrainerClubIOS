//
//  NewClassViewContract.swift
//  ThePersonalTrainerClub
//
//  Created by David Lopez Rodriguez on 11/11/2018.
//  Copyright © 2018 eXceptionCoders. All rights reserved.
//

import Foundation

enum NewClassContract {
    typealias View = NewClassView
    typealias Presenter = NewClassPresenter
    typealias Navigator = NewClassNavigator
}

protocol NewClassView: BaseContract.View {
    func setUser(_ user: UserModel)
    func resetInputs()
}

protocol NewClassPresenter: BaseContract.Presenter {
    func fetchUser()
    func onCreate(sportIndex: Int, locationIndex: Int, description: String, price: Float, quota: Int)
}

protocol NewClassNavigator: BaseContract.Navigator {
    
}
