//
//  Restaurant+Convenience.swift
//  PrivateYelp
//
//  Created by Kelson Hartle on 8/19/20.
//  Copyright © 2020 Sean Kelson. All rights reserved.
//

import Foundation
import CoreData

extension Restaurant {
    
    convenience init(address: String,
                     cusineType: String,
                     latitude: String,
                     longitude: String,
                     name: String,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.address = address
        self.cuisineType = cusineType
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }
}
