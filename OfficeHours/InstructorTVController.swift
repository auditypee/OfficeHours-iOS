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
    var frC: NSFetchRequest<Course>!
    var frI: NSFetchRequest<Instructor>!
    
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "instCell", for: indexPath) as! InstructorCell

        let instructor = fetchedResultsController.object(at: indexPath)
        // Configure the cell...
        configureCell(cell, withInstructor: instructor)
        return cell
    }
    
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
        for c in courses {
            coursesString += c.course_num! + "\n"
        }
        
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
        
        let fetchRequest: NSFetchRequest<Instructor> = Instructor.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "inst_id", ascending: true)
        
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
    var _fetchedResultsController: NSFetchedResultsController<Instructor>? = nil
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
