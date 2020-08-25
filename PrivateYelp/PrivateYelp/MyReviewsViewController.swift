//
//  MyReviewsViewController.swift
//  PrivateYelp
//
//  Created by Sean Acres on 8/20/20.
//  Copyright © 2020 Sean Kelson. All rights reserved.
//

import UIKit
import CoreData

class MyReviewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapButton: UIButton!
    
    var controller: ModelController?
    var reviews: [Review] = []
    var user: User?
    
    lazy var fetchResultsController: NSFetchedResultsController<Review> = {

        let fetchRequest: NSFetchRequest<Review> = Review.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "menuItem", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "user.name == %@", user?.name ?? "")

        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataStack.shared.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)

        frc.delegate = self

        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }

        return frc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        setUpViews()
        print("CONTROLLA: \(controller)")
        //loadReviews()
    }
    
    private func setUpViews() {
        let nib = UINib(nibName: "ReviewTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReviewCell")
        
        //Set up shadows
        
        mapButton.layer.shadowColor = UIColor.black.cgColor
        mapButton.layer.shadowOpacity = 0.25
        mapButton.layer.shadowRadius = 5
        mapButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        mapButton.layer.masksToBounds = false
    }
    
    func loadReviews() {
        let request: NSFetchRequest<Review> = Review.fetchRequest()
        do {
            reviews = try CoreDataStack.shared.mainContext.fetch(request)
        } catch {
            print("Unable to load reviews.")
        }
        tableView.reloadData()
    }
    
    @IBAction func mapButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowReviewDetailSegue" {
            let destinationVC = segue.destination as? ReviewRatingChecklistViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let reviewTapped = fetchResultsController.object(at: indexPath)
            
            destinationVC?.review = reviewTapped
            destinationVC?.restaurant = reviewTapped.restaurant
            destinationVC?.user = reviewTapped.user
            destinationVC?.controller = self.controller
        }
    }
}

extension MyReviewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewTableViewCell else { return UITableViewCell() }
        
        let review = fetchResultsController.object(at: indexPath)
        cell.review = review
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let reviewBeingDeleted = fetchResultsController.object(at: indexPath)
            guard let reviewsRestaurant = reviewBeingDeleted.restaurant else { return }
            
            controller?.deleteRestaurantAndReview(objectOneDelete: reviewsRestaurant, objectTwoDelete: reviewBeingDeleted)
        }
    }
}

extension MyReviewsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        let sectionSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(sectionSet, with: .automatic)
        case .delete:
            tableView.deleteSections(sectionSet, with: .automatic)
        default:
            return
        }
    }
}

extension MyReviewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowReviewDetailSegue", sender: tableView)
    }
}
