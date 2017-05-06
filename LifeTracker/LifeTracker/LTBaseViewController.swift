//
//  LTBaseViewController.swift
//  LifeTracker
//
//  Created by Sergey Spivakov on 4/8/17.
//  Copyright © 2017 Sergey Spivakov. All rights reserved.
//

import UIKit

class LTBaseViewController: UIViewController {

    /// Custom loading view
    var loadingView: LTProgressIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadingView = LTProgressIndicator.instantiateFromNib(nibName: "LTProgressIndicator", bundle: Bundle(for: type(of: self)), frame: self.view.frame, bounds:self.view.bounds, caption: "")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
