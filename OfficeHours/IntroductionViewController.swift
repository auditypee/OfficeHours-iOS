//
//  IntroductionViewController.swift
//  OfficeHours
//
//  Created by Audi on 12/3/18.
//  Copyright © 2018 Audi. All rights reserved.
//
/*
 An app that allows the user to get a list of all the instructors and tas for classes.
 It shows the availability of each person and where their office hours are located.
 
 literally delete the app if you want to get rid of its core data. took me waaaaaay too long to figure it out
 
 Functions:
 TODO: - Sends notification if requested
 TODO: - Implement filter of courses that have been favorited
 
 */
import UIKit
import CoreData

class IntroductionViewController: UIViewController {
    @IBOutlet weak var toInstructorsBtn: UIButton!
    @IBOutlet weak var toTAsBtn: UIButton!
    
    
    let jsonParser = JsonParser()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // where we will get the data from
    let urlData = "https://api.jsonbin.io/b/5c11f7aeec62650f24de6ea5"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJSONDataIfNeeded()
        
        // initialize the buttons to make it look nice
        toInstructorsBtn.layer.cornerRadius = 4.0
        toInstructorsBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        toInstructorsBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        toInstructorsBtn.layer.shadowOpacity = 1.0
        
        
        toTAsBtn.layer.cornerRadius = 4.0
        toTAsBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        toTAsBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        toTAsBtn.layer.shadowOpacity = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "toTa") {
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        } else if (segue.identifier == "toInstructor") {
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
    }
 
    
    // MARK: - Downloading JSON
    
    func downloadJSONDataIfNeeded() {
        // only need to check if the course entity is empty.
        let frC: NSFetchRequest<Course> = Course.fetchRequest()
        
        let count = try! managedObjectContext.count(for: frC)
        
        guard count == 0 else {
            print("Data already downloaded")
            return
        }
        
        do {
            let results = try managedObjectContext.fetch(frC)
            results.forEach( { managedObjectContext.delete($0) } )
            try managedObjectContext.save()
            
            downloadJSON(urlString: urlData)
        } catch {
            print("Error in fetching results: \(error)")
        }
    }
    /*
     Downloads JSON data from a URL
     does error checking
     goes off from main thread to download the json data
        changes objects into entities
    */
    func downloadJSON(urlString: String) {
        // error checks the url
        guard let url = URL(string: urlString) else {
            presentAlert(title: "Error", message: "Invalid URL")
            return
        }
        
        // starts a task with the url
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            let httpResponse = response as? HTTPURLResponse
            // checks if the servers are running and there is actual data and no errors
            guard httpResponse!.statusCode == 200, data != nil, error == nil else {
                self.presentAlert(title: "Error", message: "No JSON data downloaded")
                return
            }
            
            // runs the json parser
            // TODO: - Convert the array into its corresponding Entity. Most difficult part I think, should take an entire day
            DispatchQueue.main.async {
                
                
                // extracts the json data into an array of the corresponding objects
                let courseObjects = self.jsonParser.extractCourses(data: data)
                let instructorObjects = self.jsonParser.extractInstructors(data: data)
                let taObjects = self.jsonParser.extractTAs(data: data)
                
                // sends the created objects to a function for conversion
                self.objectsToEntity(courseObj: courseObjects, instObj: instructorObjects, taObj: taObjects)
                
                do {
                    try self.managedObjectContext.save()
                } catch {
                    print("Failed to save context: \(error)")
                }
                
            }
        }
        // resume task
        task.resume()
    }
    /*
     This function creates entities out of the objects from the json parser
     */
    func objectsToEntity(courseObj: [CourseObject], instObj: [InstructorObject], taObj: [TaObject]) {
        let courseEntity = NSEntityDescription.entity(forEntityName: "Course", in: managedObjectContext)!
        
        let instructorEntity = NSEntityDescription.entity(forEntityName: "Instructor", in: managedObjectContext)!
        let instOHEntity = NSEntityDescription.entity(forEntityName: "Inst_Office_Hours", in: managedObjectContext)!
        
        let taEntity = NSEntityDescription.entity(forEntityName: "TA", in: managedObjectContext)!
        let taOHEntity = NSEntityDescription.entity(forEntityName: "TA_Office_Hours", in: managedObjectContext)!

        
        // convert instructorObjects into instructorEntities
        for i in instObj {
            // create instructor entities
            let instructor = Instructor(entity: instructorEntity, insertInto: managedObjectContext)
            instructor.inst_id = Int16(i.instructorID)!
            instructor.inst_name = i.name
            instructor.inst_office_room = i.officeRoom
            
            // creates instructor's office hours entities
            for oh in i.officeDays {
                // create the instructor office hours entity from the object's array
                let instOH = Inst_Office_Hours(entity: instOHEntity, insertInto: managedObjectContext)
                instOH.office_days = oh.officeDay
                instOH.office_hours = oh.officeHours
                // relationships to instructor
                instOH.has_office_hours = instructor
                instructor.addToInst_office_hours(instOH)
            }
        }
        
        
        // converts courseObjects into courseEntities
        for c in courseObj {
            let course = Course(entity: courseEntity, insertInto: managedObjectContext)
            
            // initializes the course entities with data from the course objects
            course.inst_id = Int16(c.instructorID)!
            course.course_id = Int16(c.courseID)!
            course.course_name = c.name
            course.course_hours = c.hours
            course.course_room = c.room
            course.course_num = c.num
            course.course_days = c.days
            course.favorite = false
            // fetches the instructor entities
            let fetchRequest: NSFetchRequest<Instructor> = Instructor.fetchRequest()
            // matches the course to its instructor using id matching
            // could be faster, i don't know how to implement that yet
            do {
                let instructors = try managedObjectContext.fetch(fetchRequest)
                for i in instructors {
                    // if one of the instructors has this course, add that relationship
                    if (i.inst_id == course.inst_id) {
                        course.instructor = i
                        // adds the course relationship back to the instructor
                        i.addToCourses(course)
                    }
                }
            // error checks
            } catch {
                print("Could not fetch instructorEntity contents for courseObj: \(error)")
            }
            //print("Instructor for \(String(describing: course.course_name)) is \(String(describing: instHasCourse.inst_name))")
        }
 
        
        // converts taObjects into taEntities
        for t in taObj {
            // creates ta entities
            let ta = TA(entity: taEntity, insertInto: managedObjectContext)
            ta.course_id = Int16(t.courseID)!
            ta.ta_name = t.name
            ta.ta_office_room = t.officeRoom
            
            // creates ta's office hours entities
            for oh in t.officeDays {
                // creates ta's office hours entities from the object's array
                let taOH = TA_Office_Hours(entity: taOHEntity, insertInto: managedObjectContext)
                taOH.office_day = oh.officeDay
                taOH.office_hours = oh.officeHours
                // relationships to ta
                taOH.has_office_hours = ta
                ta.addToTa_office_hours(taOH)
            }
            
            // get the course entities
            let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
            // matches the ta to their course
            do {
                let courses = try managedObjectContext.fetch(fetchRequest)
                
                for c in courses {
                    // if one of the courses has this ta, add those relationships
                    if (c.course_id == ta.course_id) {
                        ta.course = c
                        c.addToTas(ta)
                    }
                }
            } catch {
                print("Could not fetch courseEntity contents for taObj: \(error)")
            }
        }
        
    }
    
    // shows the alert onscreen
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

}
