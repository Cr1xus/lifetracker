//
//  LTExerciseDetailTableViewController.swift
//  LifeTracker
//
//  Created by Sergey Spivakov on 4/8/17.
//  Copyright © 2017 Sergey Spivakov. All rights reserved.
//

import UIKit

class LTExerciseDetailTableViewController: UITableViewController {

    //MARK: - Properties
    @IBOutlet weak var imgIV: UIImageView!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    var exercise: Exercise?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let exercise = exercise else {
            return
        }
        
        nameLbl.text = exercise.name
        if let type = exercise.type{
            typeLbl.text = type
            
            switch type {
            case LTExerciseType.biceps.rawValue:
                imgIV.image = UIImage(named: "bicepsBigImage")
            case LTExerciseType.hammerBiceps.rawValue:
                imgIV.image = UIImage(named: "hummerBicepsBigImage")
            default:
                break
            }
        }
        
        //date conversion
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "en_US")
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        dateLbl.text = dateFormatter.string(from: exercise.date! as Date)
        let timeComponents = secondsToHoursMinutesSeconds(seconds: exercise.time)
        
        timeLbl.text = "\(timeComponents.hours)h \(timeComponents.minutes)m \(timeComponents.seconds)s"
        amountLbl.text = "\(exercise.count)"
        
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int64) -> (hours: Int64, minutes: Int64, seconds: Int64) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
