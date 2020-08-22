//
//  Review+Convenience.swift
//  PrivateYelp
//
//  Created by Kelson Hartle on 8/19/20.
//  Copyright © 2020 Sean Kelson. All rights reserved.
//

import Foundation
import CoreData

extension Review {
    
    convenience init(overallRating: Double,
                     dirtyBathrooms: Bool = false,
                     fineDining: Bool = false,
                     goodForDates: Bool = false,
                     noKids: Bool = false,
                     itemPhoto: Data,
                     menuItem: String,
                     reviewNotes: String,
                     smallSpace: Bool = false,
                     for restauraunt: Restaurant,
                     from user: User,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.overallRating = overallRating
        self.dirtyBathrooms = dirtyBathrooms
        self.fineDining = fineDining
        self.goodForDates = goodForDates
        self.itemPhoto = itemPhoto
        self.menuItem = menuItem
        self.noKids = noKids
        self.reviewNotes = reviewNotes
        self.smallSpace = smallSpace
        self.restaurant = restauraunt
        self.user = user
    }
}
