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
        print(restaurant?.name)
        print(restaurant?.reviews?.count)
        print(user?.reviews?.count)
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
    
    @IBAction func noKidsTapped(_ sender: Any) {
        if !self.isKidsSelected {
            self.noKidsButton.setImage(UIImage(named: "checklistButtonSelected"), for: .normal)
            self.isKidsSelected = true
        } else {
            self.noKidsButton.setImage(UIImage(named: "checklistButtonUnselected"), for: .normal)
            self.isKidsSelected = false
        }
    }
    
    @IBAction func goodForDatesTapped(_ sender: Any) {
        if !self.isGoodForDatesSelected {
            self.goodForDatesButton.setImage(UIImage(named: "checklistButtonSelected"), for: .normal)
            self.isGoodForDatesSelected = true
        } else {
            self.goodForDatesButton.setImage(UIImage(named: "checklistButtonUnselected"), for: .normal)
            self.isGoodForDatesSelected = false
        }
    }
    
    @IBAction func smallSpaceTapped(_ sender: Any) {
        if !self.isSmallSpaceSelected {
            self.smallSpaceButton.setImage(UIImage(named: "checklistButtonSelected"), for: .normal)
            self.isSmallSpaceSelected = true
        } else {
            self.smallSpaceButton.setImage(UIImage(named: "checklistButtonUnselected"), for: .normal)
            self.isSmallSpaceSelected = false
        }
    }
    
    @IBAction func dirtyBathroomsTapped(_ sender: Any) {
        if !self.isDirtyBathroomsSelected {
            self.dirtyBathroomsButton.setImage(UIImage(named: "checklistButtonSelected"), for: .normal)
            self.isDirtyBathroomsSelected = true
        } else {
            self.dirtyBathroomsButton.setImage(UIImage(named: "checklistButtonUnselected"), for: .normal)
            self.isDirtyBathroomsSelected = false
        }
    }
    
    @IBAction func fineDiningTapped(_ sender: Any) {
        if !self.isFineDiningSelected {
            self.fineDiningButton.setImage(UIImage(named: "checklistButtonSelected"), for: .normal)
            self.isFineDiningSelected = true
        } else {
            self.fineDiningButton.setImage(UIImage(named: "checklistButtonUnselected"), for: .normal)
            self.isFineDiningSelected = false
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if review == nil {
            guard let image = UIImage(named: "nextButton") else { return }
            guard let pngData = image.pngData() else { return }
            
            guard let restaurant = restaurant else { return }
            guard let user = user else { return }

            _ = Review(overallRating: Double(overallRatingValue), dirtyBathrooms: isDirtyBathroomsSelected, fineDining: isFineDiningSelected, goodForDates: isGoodForDatesSelected, noKids: isKidsSelected, itemPhoto: pngData, menuItem: "", reviewNotes: "", smallSpace: isSmallSpaceSelected, for: restaurant, from: user)
            controller?.saveToPersistentStore()
        }
        
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        guard let image = UIImage(named: "nextButton") else { return }
        guard let pngData = image.pngData() else { return }
        
        guard let restaurant = restaurant else { return }
        guard let user = user else { return }
        
        if review == nil {
            let reviewCreated = Review(overallRating: Double(overallRatingValue), dirtyBathrooms: isDirtyBathroomsSelected, fineDining: isFineDiningSelected, goodForDates: isGoodForDatesSelected, noKids: isKidsSelected, itemPhoto: pngData, menuItem: "", reviewNotes: "", smallSpace: isSmallSpaceSelected, for: restaurant, from: user)
            review = reviewCreated
        }
        
        controller?.saveToPersistentStore()
        
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
