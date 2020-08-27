//
//  ReviewWhatHadViewController.swift
//  PrivateYelp
//
//  Created by Sean Acres on 8/19/20.
//  Copyright © 2020 Sean Kelson. All rights reserved.
//

import UIKit

class ReviewWhatHadViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var whatHadTextView: UITextView!
    
    // MARK: - Properties
    var restaurant: Restaurant?
    var review: Review?
    var controller: ModelController?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        updateViews()
    }
    
    // MARK: - Private functions
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
        
        whatHadTextView.becomeFirstResponder()
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
        
        if let menuItem = self.review?.menuItem {
            self.whatHadTextView.text = menuItem
        }
    }
    
    private func updateReview(review: Review) {
        
        guard let restaurant = review.restaurant else { return }
        guard let user = review.user else { return }
        
        controller?.updateReview(review: review, overallRating: review.overallRating, dirtyBathrooms: review.dirtyBathrooms, fineDining: review.fineDining, goodForDates: review.goodForDates, itemPhoto: review.itemPhoto, menuItem: review.menuItem ?? "", noKids: review.noKids, reviewNotes: review.reviewNotes ?? "", smallSpace: review.smallSpace, restauraunt: restaurant, user: user)
    }
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        self.review?.menuItem = self.whatHadTextView.text
        guard let review = review else { return }
        updateReview(review: review)
                
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.review?.menuItem = self.whatHadTextView.text
        
        guard let review = review else { return }
        updateReview(review: review)
        
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
