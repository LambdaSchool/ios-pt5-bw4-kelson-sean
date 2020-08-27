//
//  ModelController.swift
//  PrivateYelp
//
//  Created by Kelson Hartle on 8/19/20.
//  Copyright © 2020 Sean Kelson. All rights reserved.
//

import Foundation
import CoreData

class ModelController {
    
    @discardableResult func oneTimeCreateUser(name: String, identifier: UUID = UUID()) -> User {
        
        let newUser = User(name: name)
        
        CoreDataStack.shared.saveToPersistentStore()
        
        print(newUser)
        return newUser
    }
    
    @discardableResult func createReview(overallRating: Double, dirtyBathrooms: Bool, fineDining: Bool, goodForDates: Bool, itemPhoto: Data?, menuItem: String, noKids: Bool, reviewNotes: String, smallSpace: Bool, restauraunt: Restaurant, user: User ) -> Review {
        
        let newReview = Review(overallRating: overallRating, dirtyBathrooms: dirtyBathrooms, fineDining: fineDining, goodForDates: goodForDates, noKids: noKids, itemPhoto: itemPhoto, menuItem: menuItem, reviewNotes: reviewNotes, smallSpace: smallSpace, for: restauraunt, from: user, context: CoreDataStack.shared.mainContext)
        CoreDataStack.shared.saveToPersistentStore()
        
        return newReview
    }
    
    func updateReview(review: Review, overallRating: Double, dirtyBathrooms: Bool, fineDining: Bool, goodForDates: Bool, itemPhoto: Data?, menuItem: String, noKids: Bool, reviewNotes: String, smallSpace: Bool, restauraunt: Restaurant, user: User) {
        review.overallRating = overallRating
        review.dirtyBathrooms = dirtyBathrooms
        review.fineDining = fineDining
        review.goodForDates = goodForDates
        review.itemPhoto = itemPhoto
        review.menuItem = menuItem
        review.noKids = noKids
        review.reviewNotes = reviewNotes
        review.smallSpace = smallSpace
        review.restaurant = restauraunt
        review.user = user
        
        CoreDataStack.shared.saveToPersistentStore()
        
    }
    
    func deleteRestaurantAndReview(objectOneDelete: NSManagedObject, objectTwoDelete: NSManagedObject) {
        
        CoreDataStack.shared.mainContext.delete(objectOneDelete)
        CoreDataStack.shared.mainContext.delete(objectTwoDelete)
        CoreDataStack.shared.saveToPersistentStore()
    }
}
