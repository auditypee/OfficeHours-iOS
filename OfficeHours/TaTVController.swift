//
//  TaTVController.swift
//  OfficeHours
//
//  Created by Audi on 12/3/18.
//  Copyright © 2018 Audi. All rights reserved.
//

import UIKit
import CoreData

class TaTVController: UITableViewController, NSFetchedResultsControllerDelegate {
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let check = CheckAvailability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController:")
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    /*
     trailing swipe for each cell
     used to favorite an instructor
     each content in the trailing swipe is tied to the course number
     */
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selTA = fetchedResultsController.object(at: indexPath)
        let course = selTA.course!
        
        let favorite = UIContextualAction(style: .normal, title: "\(course.course_num!)") { (action, view, completionHandler: (Bool) -> Void) in
            // favorites or unfavorites selected
            course.favorite = !course.favorite
            // resets row
            self.tableView.reloadRows(at: [indexPath], with: .none)
            completionHandler(true)
        }
        if course.favorite {
            favorite.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        
        // sets the contextualaction into the swipeactions
        let configuration = UISwipeActionsConfiguration(actions: [favorite])
        // stops full swipe of a cell
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taCell", for: indexPath) as! TACell

        let ta = fetchedResultsController.object(at: indexPath)
        // Configure the cell...
        configureCell(cell, withTa: ta)
        
        return cell
    }
    
    // configures the cell for each instructor info
    func configureCell(_ cell: TACell, withTa ta: TA) {
        cell.taNameLabel.text = ta.ta_name
        cell.officeRoomLabel.text = ta.ta_office_room
        
        let officeDays = ta.ta_office_hours?.allObjects as! [TA_Office_Hours]
        
        // gets the availability of the ta using the availability class
        var available = false
        for t in officeDays {
            if (check.checkAvailability(timeString: t.office_hours!, officeDay: t.office_day!)) {
                available = true
            }
        }
        // shows availability: available = green, not available = red
        if (available) {
            cell.availabilityLabel.text = "Available"
            cell.availabilityLabel.textColor = UIColor.green
        } else {
            cell.availabilityLabel.text = "Not Available"
            cell.availabilityLabel.textColor = UIColor.red
        }
        
        // gets the course of the ta
        // shows if course has been favorited
        let course = ta.course!
        cell.favImgView.isHidden = !course.favorite
        cell.courseNumLabel.text = course.course_num
        
    }
    
    // MARK: - FetchedResultsController
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    var fetchedResultsController: NSFetchedResultsController<TA> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<TA> = TA.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "ta_name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<TA>? = nil

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "taDetail") {
            let destVC = segue.destination as! TaDetailViewController
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let ta = fetchedResultsController.object(at: indexPath)
                destVC.navigationItem.title = ta.ta_name
                
                let officeHoursInfo = officeHoursInfoToString(ta: ta)
                destVC.officeHoursString = officeHoursInfo
                
                let courseInfo = coursesToString(ta: ta)
                destVC.courseInfoString = courseInfo
            }
        }
    }

    // gets a ta's office hours and turns it into a string
    func officeHoursInfoToString(ta: TA) -> String {
        var officeHoursInfo = ""
        
        let officeHours = ta.ta_office_hours?.allObjects as! [TA_Office_Hours]
        for oh in officeHours {
            officeHoursInfo += "\(oh.office_day!) \(oh.office_hours!)\n"
        }
        
        return officeHoursInfo
    }
    
    // gets a ta's course and turs it into a string
    func coursesToString(ta: TA) -> String {
        var coursesInfo = ""
        
        let c = ta.course!
        
        coursesInfo += "\(c.course_name!)\n"
        coursesInfo += "\t\(c.course_num!)\n"
        coursesInfo += "\t\(c.course_room!)\n"
        coursesInfo += "\t\(c.course_days!) \(c.course_hours!)\n"
        
        return coursesInfo
    }

}
