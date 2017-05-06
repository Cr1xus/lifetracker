//
//  ViewController.swift
//  LifeTracker
//
//  Created by Sergey Spivakov on 3/14/17.
//  Copyright © 2017 Sergey Spivakov. All rights reserved.
//

import UIKit
import CoreData

class LTViewController: LTBaseViewController {
    // MARK: - Properties
    @IBOutlet var tableView: UITableView!
    var currentlySelectedRow: Exercise?
    
    static let segueToDetailExercise = "segueToDetailExercise"
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.purple
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(LTViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Exercise> = {
        
        let appDelegate = UIApplication.shared.delegate as? LTAppDelegate
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (appDelegate?.storage.context)!, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    ///Returns last update string
    func getRefreshControlString() -> NSAttributedString{
        let formatter =  DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        let title = "Last update: \(formatter.string(from: Date()))"
        let attrDict = [NSForegroundColorAttributeName: UIColor.white]
        let attrStr: NSAttributedString = NSAttributedString(string: title, attributes: attrDict)
        
        return attrStr
    }
    
    
    /// Updates tableView data
    func handleRefresh(refreshControl: UIRefreshControl) {
        updateView()
        
        let attrStr: NSAttributedString = self.getRefreshControlString()
        self.refreshControl.attributedTitle = attrStr
        self.refreshControl.endRefreshing()
    }
    
    fileprivate func updateView() {
        var hasExercises = false
        self.loadingView?.show(whereToShow: self)
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        
        if let exercises = fetchedResultsController.fetchedObjects {
            hasExercises = exercises.count > 0
        }
        
        tableView.isHidden = !hasExercises
        
        self.loadingView?.hide(whereToHide: self)
    }
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addSubview(self.refreshControl)
        self.tableView.register(UITableViewCell.self,forCellReuseIdentifier: "Cell")
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.updateView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension LTViewController: UITableViewDataSource {
    
    ///Returns UILabel with specified text
    func getBackgroundMessageLabel(text:String, bounds:CGRect) -> UILabel{
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        messageLabel.text = text;
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignment.center;
        messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
        messageLabel.sizeToFit()
        
        return messageLabel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let exercises = fetchedResultsController.fetchedObjects
        
        if exercises == nil || exercises?.count == 0{
            // Display a message when the table is empty
            let messageLabel = self.getBackgroundMessageLabel(text: "No data is currently available", bounds: self.view.bounds)
            self.tableView.backgroundView = messageLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            return 0
        }else{
            self.tableView.backgroundView = nil
            return exercises!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.reuseIdentifier, for: indexPath) as? ExerciseTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        // Fetch
        let exercise = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.nameLbl.text = exercise.name
        
        //date conversion
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "en_US")
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        cell.dateLbl.text = dateFormatter.string(from: exercise.date! as Date)
        if let type = exercise.type {
            switch type {
            case LTExerciseType.biceps.rawValue:
                cell.typeIV.image = UIImage(named: "bicepsGym")
                break
            case LTExerciseType.hammerBiceps.rawValue:
                cell.typeIV.image = UIImage(named: "hummerBiceps")
                break
                
            default:
                break
            }
        }
        return cell
    }
}

extension LTViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            print("...")
        }
    }
}

//MARK: - UITableViewDelegate implementation
extension LTViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentlySelectedRow = fetchedResultsController.object(at: indexPath)
        self.performSegue(withIdentifier: LTViewController.segueToDetailExercise, sender: self)
    }
}

//MARK: - Transition between VC implementation
extension LTViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == LTViewController.segueToDetailExercise){
            guard let destVC = segue.destination as? LTExerciseDetailTableViewController else{
                return
            }
            guard let exercise = self.currentlySelectedRow else{
                return
            }
            destVC.exercise = exercise
        }
    }
}

