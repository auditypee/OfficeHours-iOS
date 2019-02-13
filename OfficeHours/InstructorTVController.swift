//
//  InstructorTVController.swift
//  OfficeHours
//
//  Created by Audi on 12/3/18.
//  Copyright © 2018 Audi. All rights reserved.
//

import UIKit
import CoreData

class InstructorTVController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let check = CheckAvailability()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        let selInstructor = fetchedResultsController.object(at: indexPath)
        let courses = selInstructor.courses?.allObjects as! [Course]
        
        var favorites = [UIContextualAction]()
        for c in courses {
            let fav = UIContextualAction(style: .normal, title: "\(c.course_num!)") { (action, view, completionHandler: (Bool) -> Void) in
                // favorites or unfavorites selected
                c.favorite = !c.favorite
                // resets row
                self.tableView.reloadRows(at: [indexPath], with: .none)
                completionHandler(true)
            }
            if c.favorite {
                fav.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            }
            // adds the course to the array of contextual action
            favorites.append(fav)
        }
        
        
        let configuration = UISwipeActionsConfiguration(actions: favorites)
        // stops full swipe of a cell
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "instCell", for: indexPath) as! InstructorCell

        let instructor = fetchedResultsController.object(at: indexPath)
        // Configure the cell...
        configureCell(cell, withInstructor: instructor)
        return cell
    }
    
    // changes the cell's textviews and labels to its corresponding details
    func configureCell(_ cell: InstructorCell, withInstructor instructor: Instructor) {
        cell.instructorNameLabel.text = instructor.inst_name
        cell.officeRoomLabel.text = instructor.inst_office_room
        
        let officeDays = instructor.inst_office_hours?.allObjects as! [Inst_Office_Hours]
        
        // set the availability for each cell
        var available = false
        for i in officeDays {
            // if any of the officeHours return true, then set it to true
            // otherwise it's always false
            if (check.checkAvailability(timeString: i.office_hours!, officeDay: i.office_days!)) {
                available = true
            }
        }
        
        // changes the availability label to either not available and available
        if (available) {
            cell.availabilityLabel.text = "Available"
            cell.availabilityLabel.textColor = UIColor.green
        } else {
            cell.availabilityLabel.text = "Not Available"
            cell.availabilityLabel.textColor = UIColor.red
        }
        
        // set the courses for each cell
        let courses = instructor.courses?.allObjects as! [Course]
        var coursesString = ""
        
        var fav = false
        
        for c in courses {
            coursesString += c.course_num! + "\n"
            // checks if current cell has a favorited course
            if c.favorite {
                fav = true
            }
        }
        // unhides the image view if there is a favorited course
        cell.favImgView.isHidden = !fav
        cell.coursesTextView.text = coursesString
    }
    
    // MARK: - FetchedResultsController
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    var fetchedResultsController: NSFetchedResultsController<Instructor> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let instFetchRequest: NSFetchRequest<Instructor> = Instructor.fetchRequest()
        
        // Set the batch size to a suitable number.
        instFetchRequest.fetchBatchSize = 20
        // Edit the sort key as appropriate.
        let idSortDescriptor = NSSortDescriptor(key: "inst_id", ascending: true)
        
        instFetchRequest.sortDescriptors = [idSortDescriptor]
        
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: instFetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
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
    var _fetchedResultsController: NSFetchedResultsController<Instructor>? = nil
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "instructorDetail") {
            let destVC = segue.destination as! InstructorDetailViewController
            
            // selectedRow gets its details sent to the InstructorDetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let instructor = fetchedResultsController.object(at: indexPath)
                destVC.navigationItem.title = instructor.inst_name
                
                let officeHoursInfo = officeHourseToString(instructor: instructor)
                destVC.officeHoursString = officeHoursInfo
                
                let coursesInfo = coursesToString(instructor: instructor)
                destVC.courseInfoString = coursesInfo
            }
        }
    }
    
    // gets an instructor's office hours and turns it into a string
    func officeHourseToString(instructor: Instructor) -> String {
        var officeHoursInfo = ""
        
        let officeHours = instructor.inst_office_hours?.allObjects as! [Inst_Office_Hours]
        for oh in officeHours {
            officeHoursInfo += "\(oh.office_days!) \(oh.office_hours!)\n"
        }
        
        return officeHoursInfo
    }
    
    // gets an instructor's courses and turns it into a string
    func coursesToString(instructor: Instructor) -> String {
        var coursesInfo = ""
        
        let courses = instructor.courses?.allObjects as! [Course]
        
        for c in courses {
            coursesInfo += "\(c.course_name!)\n"
            coursesInfo += "\t\(c.course_num!)\n"
            coursesInfo += "\t\(c.course_room!)\n"
            coursesInfo += "\t\(c.course_days!) \(c.course_hours!)\n"
        }
        
        
        return coursesInfo
    }
 

}
