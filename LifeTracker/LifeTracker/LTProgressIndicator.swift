//
//  LTProgressIndicator.swift
//
//  Created by Sergey Spivakov on 2/4/17.
//  Copyright © 2017 Sergey Spivakov. All rights reserved.
//

import UIKit

class LTProgressIndicator: UIView {
    
    ///Activity indicator
    @IBOutlet weak var progressIndicatorCircle: UIActivityIndicatorView!
    
    ///Action title
    @IBOutlet weak var progressIndicatorCaption: UILabel!
    
    ///Holds priority
    var numberOfCalls: Int = 0
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /**
     Loads/Unarchives current view
     - Parameter nibName: Represents xib to load
     - Parameter bundle: Represents bundle where xib is located
     - Parameter frame: Size to scratch
     - Parameter bounds: Size to scratch
     - Parameter caption: Title for the view
     - Returns: UIView subclass(LTProgressIndicator)
     */
    class func instantiateFromNib(nibName: String, bundle: Bundle, frame:CGRect, bounds:CGRect, caption: String?) -> LTProgressIndicator?{
        var view: LTProgressIndicator?
        let objects = bundle.loadNibNamed(nibName, owner: self, options: nil)
        
        for arrIt in objects!{
            if((arrIt as? LTProgressIndicator) != nil){
                view = arrIt as? LTProgressIndicator
                view?.frame = frame
                view?.bounds = bounds
                break;
            }
        }
        if(view != nil){
            view!.backgroundColor = UIColor.init(white: 0.667,alpha:0.5 )
            if(caption != nil){
                view?.progressIndicatorCaption.text = caption!
            }
        }
        return view
    }
    
    override init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    /**
     Shows current loader with activity indicator
     - Parameter whereToShow: Indicates view controller where current view has to be attached
     */
    func show(whereToShow: UIViewController){
        let lockQueue = DispatchQueue(label: "com.LTProgressIndicator.LockQueueShow")
        lockQueue.sync() {
            numberOfCalls += 1
            if(numberOfCalls == 1){
                whereToShow.view.addSubview(self)
                self.progressIndicatorCircle.startAnimating()
            }
        }
    }
    
    /**
     Hides current view
     - Parameter whereToHide: Indicates view controller where current view is attached
     */
    func hide(whereToHide: UIViewController){
        let lockQueue = DispatchQueue(label: "com.LTProgressIndicator.LockQueueHide")
        lockQueue.sync() {
            numberOfCalls -= 1
            if(numberOfCalls < 0){
                numberOfCalls = 0
            }
            if(numberOfCalls == 0){
                self.progressIndicatorCircle.stopAnimating()
                self.removeFromSuperview()
            }
        }
    }
    
}

