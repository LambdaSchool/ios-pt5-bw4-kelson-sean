//
//  ReviewRatingChecklistViewController.swift
//  PrivateYelp
//
//  Created by Sean Acres on 8/19/20.
//  Copyright © 2020 Sean Kelson. All rights reserved.
//

import UIKit

class ReviewRatingChecklistViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var oneStarButton: UIButton!
    @IBOutlet weak var twoStarButton: UIButton!
    @IBOutlet weak var threeStarButton: UIButton!
    @IBOutlet weak var fourStarButton: UIButton!
    @IBOutlet weak var fiveStarButton: UIButton!
    @IBOutlet weak var noKidsButton: UIButton!
    @IBOutlet weak var goodForDatesButton: UIButton!
    @IBOutlet weak var smallSpaceButton: UIButton!
    @IBOutlet weak var dirtyBathroomsButton: UIButton!
    @IBOutlet weak var fineDiningButton: UIButton!
    
    var overallRatingValue = 0
    
    var isKidsSelected: Bool = false
    var isGoodForDatesSelected: Bool = false
    var isSmallSpaceSelected: Bool = false
    var isDirtyBathroomsSelected: Bool = false
    var isFineDiningSelected: Bool = false
    
    var restaurant: Restaurant?
    var review: Review?
    var controller: ModelController?
    var user: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        updateViews()
//        print("CONTROLLA: \(controller)")
//        print(restaurant?.reviews?.count)
//        print(user?.reviews?.count)
    }
    
    
    private func setUpViews() {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
        
        // Set up next button shadows
        nextButton.layer.shadowColor = UIColor.black.cgColor
        nextButton.layer.shadowOpacity = 0.25
        nextButton.layer.shadowRadius = 5
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        nextButton.layer.masksToBounds = false
        
        // Set up save button shadows
        saveButton.layer.shadowColor = UIColor.black.cgColor
        saveButton.layer.shadowOpacity = 0.25
        saveButton.layer.shadowRadius = 5
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        saveButton.layer.masksToBounds = false
        
        // Set up contentView appearance
        contentView.layer.cornerRadius = 15.0
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.25
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.masksToBounds = false
    }
    
    private func updateViews() {
        // Update name and address
        if let restaurant = self.restaurant {
            nameLabel.text = restaurant.name
            addressLabel.text = restaurant.address
        } else {
            self.nameLabel.text = review?.restaurant?.name
            self.addressLabel.text = review?.restaurant?.address
        }
        
        // Update rating
        if let review = self.review {
            switch review.overallRating {
            case 1:
                self.oneStarTapped(self)
            case 2:
                self.twoStarTapped(self)
            case 3:
                self.threeStarTapped(self)
            case 4:
                self.fourStarTapped(self)
            default:
                self.fiveStarTapped(self)
            }
        }
        
        //Update checklist
        if review?.dirtyBathrooms == true {
            self.dirtyBathroomsButton.setImage(UIImage(named: "checklistButtonSelected"), for: .normal)
            self.isDirtyBathroomsSelected = true
        }
        
        if review?.noKids == true {
            self.noKidsButton.setImage(UIImage(named: "checklistButtonSelected"), for: .normal)
            self.isKidsSelected = true
        }
        
        if review?.goodForDates == true {
            self.goodForDatesButton.setImage(UIImage(named: "checklistButtonSelected"), for: .normal)
            self.isGoodForDatesSelected = true
        }
        
        if review?.smallSpace == true {
            self.smallSpaceButton.setImage(UIImage(named: "checklistButtonSelected"), for: .normal)
            self.isSmallSpaceSelected = true
        }
        
        if review?.fineDining == true {
            self.fineDiningButton.setImage(UIImage(named: "checklistButtonSelected"), for: .normal)
            self.isFineDiningSelected = true
        }
    }
    
    @IBAction func oneStarTapped(_ sender: Any) {
        self.oneStarButton.setImage(UIImage(named: "starButtonSelected"), for: .normal)
        self.twoStarButton.setImage(UIImage(named: "starButtonUnselected"), for: .normal)
        self.threeStarButton.setImage(UIImage(named: "starButtonUnselected"), for: .normal)
        self.fourStarButton.setImage(UIImage(named: "starButtonUnselected"), for: .normal)
        self.fiveStarButton.setImage(UIImage(named: "starButtonUnselected"), for: .normal)
        
        overallRatingValue = 1
    }
    
    @IBAction func twoStarTapped(_ sender: Any) {
        self.oneStarButton.setImage(UIImage(named: "starButtonSelected"), for: .normal)
        self.twoStarButton.setImage(UIImage(named: "starButtonSelected"), for: .normal)
        self.threeStarButton.setImage(UIImage(named: "starButtonUnselected"), for: .normal)
        self.fourStarButton.setImage(UIImage(named: "starButtonUnselected"), for: .normal)
        self.fiveStarButton.setImage(UIImage(named: "starButtonUnselected"), for: .normal)
        
        overallRatingValue = 2
        
    }
    
    @IBAction func threeStarTapped(_ sender: Any) {
        self.oneStarButton.setImage(UIImage(named: "starButtonSelected"), for: .normal)
        self.twoStarButton.setImage(UIImage(named: "starButtonSelected"), for: .normal)
        self.threeStarButton.setImage(UIImage(named: "starButtonSelected"), for: .normal)
        self.fourStarButton.setImage(UIImage(named: "starButtonUnselected"), for: .normal)
        self.fiveStarButton.setImage(UIImage(named: "starButtonUnselected"), for: .normal)
        
        overallRatingValue = 3
    }
    
    @IBAction func fourStarTapped(_ sender: Any) {
        self.oneStarButton.setImage(UIImage(named: "starButtonSelected"), for: .normal)
        self.twoStarButton.setImage(UIImage(named: "starButtonSelected"), for: .normal)
        self.threeStarButton.setImage(UIImage(named: "starButtonSelected"), for: .normal)
        self.fourStarButton.setImage(UIImage(named: "starButtonSelected"), for: .normal)
        self.fiveStarButton.setImage(UIImage(named: "starButtonUnselected"), for: .normal)
        
        overallRatingValue = 4
    }
    
    @IBAction func fiveStarTapped(_ sender: Any) {
        self.oneStarButton.setImage(UIImage(named: "starButtonSelected"), for: .normal)
        self.twoStarButton.setImage(UIImage(named: "starButtonSelected"), for: .normal)
        self.threeStarButton.setImage(UIImage(named: "starButtonSelected"), for: .normal)
        self.fourStarButton.setImage(UIImage(named: "starButtonSelected"), for: .normal)
        self.fiveStarButton.setImage(UIImage(named: "starButtonSelected"), for: .normal)
        
        overallRatingValue = 5
        
    }
    
    private func updateReview(review: Review) {
        
        guard let restaurant = review.restaurant else { return }
        guard let user = review.user else { return }
        
        controller?.updateReview(review: review, overallRating: review.overallRating, dirtyBathrooms: review.dirtyBathrooms, fineDining: review.fineDining, goodForDates: review.goodForDates, itemPhoto: review.itemPhoto, menuItem: review.menuItem ?? "", noKids: review.noKids, reviewNotes: review.reviewNotes ?? "", smallSpace: review.smallSpace, restauraunt: restaurant, user: user)
        
    }
    
    @IBAction func noKidsTapped(_ sender: UIButton) {
        checkAndUpdateChecklist(sender: sender)
    }
    
    @IBAction func goodForDatesTapped(_ sender: UIButton) {
        checkAndUpdateChecklist(sender: sender)
    }
    
    @IBAction func smallSpaceTapped(_ sender: UIButton) {
        checkAndUpdateChecklist(sender: sender)    }
    
    @IBAction func dirtyBathroomsTapped(_ sender: UIButton) {
        checkAndUpdateChecklist(sender: sender)
    }
    
    @IBAction func fineDiningTapped(_ sender: UIButton) {
        checkAndUpdateChecklist(sender: sender)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if review != nil {
            review?.overallRating = Double(overallRatingValue)
            review?.dirtyBathrooms = isDirtyBathroomsSelected
            review?.fineDining = isFineDiningSelected
            review?.goodForDates = isGoodForDatesSelected
            review?.noKids = isKidsSelected
            
            guard let review = review else { return }
            updateReview(review: review)
        }
        
        if review == nil {
            
            guard let restaurant = restaurant else { return }
            guard let user = user else { return }
            
            controller?.createReview(overallRating: Double(overallRatingValue), dirtyBathrooms: isDirtyBathroomsSelected, fineDining: isFineDiningSelected, goodForDates: isGoodForDatesSelected, itemPhoto: nil, menuItem: "", noKids: isKidsSelected, reviewNotes: "", smallSpace: isSmallSpaceSelected, restauraunt: restaurant, user: user)
        }
                
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if review != nil {
            review?.overallRating = Double(overallRatingValue)
            review?.dirtyBathrooms = isDirtyBathroomsSelected
            review?.fineDining = isFineDiningSelected
            review?.goodForDates = isGoodForDatesSelected
            review?.noKids = isKidsSelected
            
            guard let review = review else { return }
            guard let restaurant = review.restaurant else { return }
            guard let user = review.user else { return }
            
            controller?.updateReview(review: review, overallRating: review.overallRating, dirtyBathrooms: review.dirtyBathrooms, fineDining: review.fineDining, goodForDates: review.goodForDates, itemPhoto: review.itemPhoto, menuItem: review.menuItem ?? "", noKids: review.noKids, reviewNotes: review.reviewNotes ?? "", smallSpace: review.smallSpace, restauraunt: restaurant, user: user)
        }
        
        if review == nil {
            guard let restaurant = restaurant else { return }
            guard let user = user else { return }
            
           let newReview = controller?.createReview(overallRating: Double(overallRatingValue), dirtyBathrooms: isDirtyBathroomsSelected, fineDining: isFineDiningSelected, goodForDates: isGoodForDatesSelected, itemPhoto: nil, menuItem: "", noKids: isKidsSelected, reviewNotes: "", smallSpace: isSmallSpaceSelected, restauraunt: restaurant, user: user)
            
            review = newReview
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WhatIHadSegue" {
            let destinationVC = segue.destination as? ReviewWhatHadViewController
            destinationVC?.restaurant = self.restaurant
            destinationVC?.review = self.review
            destinationVC?.controller = self.controller
        }
    }
}

// MARK: - Checking and updating checklist
extension ReviewRatingChecklistViewController {
    private func checkAndUpdateChecklist(sender: UIButton) {
        if sender == noKidsButton {
            if !self.isKidsSelected {
                self.noKidsButton.setImage(UIImage(named: "checklistButtonSelected"), for: .normal)
                self.isKidsSelected = true
            } else {
                self.noKidsButton.setImage(UIImage(named: "checklistButtonUnselected"), for: .normal)
                self.isKidsSelected = false
            }
        } else if sender == goodForDatesButton {
            if !self.isGoodForDatesSelected {
                self.goodForDatesButton.setImage(UIImage(named: "checklistButtonSelected"), for: .normal)
                self.isGoodForDatesSelected = true
            } else {
                self.goodForDatesButton.setImage(UIImage(named: "checklistButtonUnselected"), for: .normal)
                self.isGoodForDatesSelected = false
            }
        } else if sender == smallSpaceButton {
            if !self.isSmallSpaceSelected {
                self.smallSpaceButton.setImage(UIImage(named: "checklistButtonSelected"), for: .normal)
                self.isSmallSpaceSelected = true
            } else {
                self.smallSpaceButton.setImage(UIImage(named: "checklistButtonUnselected"), for: .normal)
                self.isSmallSpaceSelected = false
            }
        } else if sender == dirtyBathroomsButton {
            if !self.isDirtyBathroomsSelected {
                self.dirtyBathroomsButton.setImage(UIImage(named: "checklistButtonSelected"), for: .normal)
                self.isDirtyBathroomsSelected = true
                print(self.isDirtyBathroomsSelected)
            } else {
                self.dirtyBathroomsButton.setImage(UIImage(named: "checklistButtonUnselected"), for: .normal)
                self.isDirtyBathroomsSelected = false
            }
        } else if sender == fineDiningButton {
            if !self.isFineDiningSelected {
                self.fineDiningButton.setImage(UIImage(named: "checklistButtonSelected"), for: .normal)
                self.isFineDiningSelected = true
                print(self.isFineDiningSelected)
            } else {
                self.fineDiningButton.setImage(UIImage(named: "checklistButtonUnselected"), for: .normal)
                self.isFineDiningSelected = false
            }
        }
    }
}
