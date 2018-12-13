//
//  InstructorDetailViewController.swift
//  OfficeHours
//
//  Created by Audi on 12/12/18.
//  Copyright © 2018 Audi. All rights reserved.
//

import UIKit

class InstructorDetailViewController: UIViewController {
    @IBOutlet weak var officeHoursTextView: UITextView!
    @IBOutlet weak var courseInfoTextView: UITextView!
    
    var officeHoursString: String!
    var courseInfoString: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        officeHoursTextView.text = officeHoursString
        courseInfoTextView.text = courseInfoString
        
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
