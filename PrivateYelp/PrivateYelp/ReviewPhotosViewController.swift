//
//  ReviewPhotosViewController.swift
//  PrivateYelp
//
//  Created by Sean Acres on 8/19/20.
//  Copyright © 2020 Sean Kelson. All rights reserved.
//

import UIKit

class ReviewPhotosViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var choosePhotoButton: UIButton!
    
    var restaurant: Restaurant?
    var review: Review?
    var controller: ModelController?
    var imagePicker = UIImagePickerController()
    var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        updateViews()
        print(restaurant?.name)
        print(review?.menuItem)

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
    
    private func updateViews() {
        // Update name and address
        if let restaurant = self.restaurant {
            nameLabel.text = restaurant.name
            addressLabel.text = restaurant.address
        } else {
            self.nameLabel.text = review?.restaurant?.name
            self.addressLabel.text = review?.restaurant?.address
        }
        
        if let photoData = self.review?.itemPhoto {
            let image = UIImage(data: photoData)
            self.choosePhotoButton.setImage(image, for: .normal)
            
        }
    }
    
    private func updateReview(review: Review) {
        
        guard let restaurant = review.restaurant else { return }
        guard let user = review.user else { return }
        
        controller?.updateReview(review: review, overallRating: review.overallRating, dirtyBathrooms: review.dirtyBathrooms, fineDining: review.fineDining, goodForDates: review.goodForDates, itemPhoto: review.itemPhoto, menuItem: review.menuItem ?? "", noKids: review.noKids, reviewNotes: review.reviewNotes ?? "", smallSpace: review.smallSpace, restauraunt: restaurant, user: user)
        
    }
    
    @IBAction func addPhotoTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if let imageData = imageData {
            self.review?.itemPhoto = imageData
            guard let review = review else { return }
            updateReview(review: review)
            
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let imageData = imageData {
            self.review?.itemPhoto = imageData
            guard let review = review else { return }
            updateReview(review: review)
            
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReviewNotesSegue" {
            let destinationVC = segue.destination as? ReviewNotesViewController
            destinationVC?.restaurant = self.restaurant
            destinationVC?.review = self.review
            destinationVC?.controller = self.controller
        }
    }
}

extension ReviewPhotosViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        imageData = image.pngData()
        
        self.choosePhotoButton.setImage(image, for: .normal)
        dismiss(animated: true, completion: nil)
        
    }
}
