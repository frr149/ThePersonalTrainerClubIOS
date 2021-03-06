//
//  ClassFinderResultViewPresenter.swift
//  ThePersonalTrainerClub
//
//  Created by David Lopez Rodriguez on 06/12/2018.
//  Copyright © 2018 eXceptionCoders. All rights reserved.
//

import Foundation

class ClassFinderResultViewPresenter: BaseViewPresenter, ClassFinderResultContract.Presenter {
    private var view: ClassFinderResultContract.View
    
    private lazy var navigator: ClassFinderResultContract.Navigator = ClassFinderResultViewNavigator(view: view)
    
    private var trainerManagementUseCase: TrainerManagementUseCase
    private var findClassesUseCase: FindClassesUseCase
    
    private var classes: [ClassModel] = []
    private var page = 0
    private var perPage = 20
    
    private var _total = 0;
    var total: Int {
        get { return _total }
    }
    
    init(view: ClassFinderResultContract.View, trainerManagementUseCase: TrainerManagementUseCase, findClassesUseCase: FindClassesUseCase) {
        self.view = view
        self.trainerManagementUseCase = trainerManagementUseCase
        self.findClassesUseCase = findClassesUseCase
    }
    
    func fetchClasses(_ query: ClassFinderQuery) {
        guard let user = UserSettings.user else {
            return
        }
        
        view.showLoading()
        
        let sport = user.activities[query.sportIndex]
        let location = user.locations[query.locationIndex]
        
        var price = ""
        if query.priceFrom != nil && query.priceTo != nil {
            price = "\(query.priceFrom!)-\(query.priceTo!)"
        } else if query.priceFrom != nil {
            price = "\(query.priceFrom!)-"
        } else if query.priceTo != nil {
            price = "-\(query.priceTo!)"
        }
        
        findClassesUseCase.find(sport: sport.id, location: location, distance: query.distance, price: price, page: page, perPage: perPage) { (result, error, errorsMap) in
            self.view.hideLoading()
            
            if error != nil {
                var message = String(format: NSLocalizedString("class_finder_result_server_error", comment: ""))
                
                for (key, detail) in errorsMap ?? [:] {
                    message = String(format: "%@ \n%@: %@", message, key, detail)
                }
                
                self.view.showAlertMessage(title: nil, message: message)
                
                self.classes = []
                self.view.setClasses(self.classes, 0)
            } else {
                self._total = result?.total ?? 0
                
                self.classes = result?.classes ?? []
                self.view.setClasses(self.classes, result?.total ?? 0)
            }
        }
    }
    
    func onClassTapped(_ data: ClassModel) {
        self.navigator.navigateToClassDetail(model: data)
    }
    
    func book(_ classId: String) {
        view.showLoading()
        trainerManagementUseCase.book(classId: classId) { (succes, error, errorsMap) in
            
            self.view.hideLoading()
            if error != nil {
                var message = String(format: NSLocalizedString("booking_error", comment: ""))
                
                for (key, detail) in errorsMap ?? [:] {
                    message = String(format: "%@ \n%@: %@", message, key, detail)
                }
                
                self.view.showAlertMessage(title: nil, message: message)
            } else {
                self.view.showAlertMessage(title: nil, message: NSLocalizedString("booking_done", comment: ""))
            }
        }
    }
}
