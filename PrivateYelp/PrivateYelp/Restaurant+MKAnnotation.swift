//
//  Restaurant+MKAnnotation.swift
//  PrivateYelp
//
//  Created by Kelson Hartle on 8/21/20.
//  Copyright © 2020 Sean Kelson. All rights reserved.
//

import Foundation
import CoreData
import MapKit

extension Restaurant: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        guard (latitude != nil) else {
            return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        }
        
        guard let latitude = latitude else { return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)}
        guard let longitude = longitude else {  return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)}
        let newLatitude = latitude as NSString
        let newlatitudeValue = newLatitude.doubleValue
        let newLongitude = longitude as NSString
        let newLongitudeValue = newLongitude.doubleValue
        return CLLocationCoordinate2D(latitude: newlatitudeValue, longitude: newLongitudeValue)
    }
    
    public var title: String? {
        name
    }
    public var subtitle: String? {
        guard let restaurantReviews: [Review] = reviews?.allObjects as? [Review] else { return "" }
        var restaurantRating = 0.0
        
        for review in restaurantReviews {
            restaurantRating = review.overallRating
        }
        
        return "\(determineAmountOfStars(overallRating: restaurantRating))"
        
    }
    private func determineAmountOfStars(overallRating: Double) -> String {
        switch overallRating {
        case 1.0:
            return "⭑"
        case 2.0:
            return "⭑⭑"
        case 3.0:
            return "⭑⭑⭑"
        case 4.0:
            return "⭑⭑⭑⭑"
        case 5.0:
            return "⭑⭑⭑⭑⭑"
        default:
            return ""
        }
    }
}
