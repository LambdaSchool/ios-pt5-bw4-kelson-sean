//
//  ReviewWhatHadViewController.swift
//  PrivateYelp
//
//  Created by Sean Acres on 8/19/20.
//  Copyright © 2020 Sean Kelson. All rights reserved.
//

import UIKit

class ReviewWhatHadViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var whatHadTextView: UITextView!
    
    var restaurant: Restaurant?
    var review: Review?
    var controller: ModelController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
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
        
        nameLabel.text = self.restaurant?.name
        addressLabel.text = self.restaurant?.address
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        self.review?.menuItem = self.whatHadTextView.text
        guard let reviewCreated = review,
            let itemPhoto = reviewCreated.itemPhoto,
            let menuItem = reviewCreated.menuItem,
            let reviewNotes = reviewCreated.reviewNotes,
            let restaurant = reviewCreated.restaurant,
            let user = reviewCreated.user
            else { return }
        
        controller?.createReview(overallRating: reviewCreated.overallRating,                         dirtyBathrooms: reviewCreated.dirtyBathrooms,
                                 fineDining: reviewCreated.fineDining,
                                 goodForDates:reviewCreated.goodForDates,
                                 itemPhoto: itemPhoto,
                                 menuItem: menuItem,
                                 noKids: reviewCreated.noKids,
                                 reviewNotes: reviewNotes,
                                 smallSpace: reviewCreated.smallSpace, restauraunt: restaurant,
                                 user: user)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.review?.menuItem = self.whatHadTextView.text
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotosSegue" {
            let destinationVC = segue.destination as? ReviewPhotosViewController
            destinationVC?.restaurant = self.restaurant
            destinationVC?.review = self.review
            destinationVC?.controller = self.controller
        }
    }
}
