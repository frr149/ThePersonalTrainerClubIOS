//
//  NewClassProvider.swift
//  ThePersonalTrainerClub
//
//  Created by David Lopez Rodriguez on 11/11/2018.
//  Copyright © 2018 eXceptionCoders. All rights reserved.
//

import Foundation

class ClassProvider {
    enum ClassError: Error {
        case unprocessableEntity
        case notFound
        case otherError
    }
    
    private let webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func create(model: NewClassModel, completion: @escaping (Bool, Error?, [String: String]?) -> Void) {
        webService.load(NewClassResponse.self, from: Endpoint.newClass(requestModel: ClassProviderMapper.mapModelToEntity(model: model))) { responseObject, error in
            if let error = error {
                switch error {
                case WebServiceError.unprocessableEntity:
                    completion(false, ClassError.unprocessableEntity, responseObject?.error)
                default:
                    completion(false, ClassError.otherError, responseObject?.error)
                }
            } else {
                completion(true, nil, nil)
            }
        }
    }
    
    func find(sport: String, location: LocationModel, distance: Int, price: String, page: Int, perPage: Int, completion: @escaping (FindClassesModel?, Error?, [String: String]?) -> Void) {
        webService.load(FindClasesResponse.self, from: Endpoint.findClasses(requestModel: FindClasesRequest(
            sport: sport,
            longitude: location.coordinates[0],
            latitude: location.coordinates[1],
            distance: distance,
            price: price,
            page: page,
            perPage: perPage
        ))) { responseObject, error in
            if let error = error {
                switch error {
                case WebServiceError.unprocessableEntity:
                    completion(nil, ClassError.unprocessableEntity, responseObject?.error)
                default:
                    completion(nil, ClassError.otherError, responseObject?.error)
                }
            } else if let response = responseObject {
                completion( ClassProviderMapper.mapFindEntityToModel(data: response), nil, nil)
            } else {
                completion(nil, ClassError.otherError, responseObject?.error)
            }
        }
    }
}

class ClassProviderMapper {
    class func mapModelToEntity(model: NewClassModel) -> NewClassRequest {
        return NewClassRequest(
            instructor: model.instructor,
            sport: model.sport,
            location: LocationEntity(
                type: model.location.type,
                description: model.location.description,
                coordinates: model.location.coordinates
            ),
            description: model.description,
            price: model.price,
            duration: model.duration,
            maxusers: model.maxusers
        )
    }
    
    class func mapFindEntityToModel(data: FindClasesResponse) -> FindClassesModel {
        return FindClassesModel(
            total: data.total ?? 0,
            classes: (data.data ?? []).map { ClassProviderMapper.mapEntityToModel(data: $0) }
        )
    }
    
    class func mapEntityToModel(data: ClassEntity) -> ClassModel {
        let classData = ClassModel(
            id: data._id,
            instructor: TrainerModel(
                id: data.instructor._id,
                name: data.instructor.name,
                lastname: data.instructor.lastname,
                thumbnail: data.instructor.thumbnail
            ),
            sport: ActivityModel(
                id: data.sport._id,
                name: data.sport.name,
                icon: data.sport.icon,
                category: data.sport.category ?? ""
            ),
            location: LocationModel(
                type: data.location.type,
                coordinates: data.location.coordinates,
                description: data.place
            ),
            description: data.description,
            price: data.price,
            maxusers: data.maxusers,
            duration: data.duration,
            registered: data.registered,
            distance: nil
        )
        
        return classData
    }
}
