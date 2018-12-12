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
 
 Functions:
 TODO: - VERY IMPORTANT, FULLY ADD ALL OF JSON DATA TO SITE
 TODO: - Checks if current time is in line with someone's office hours
 TODO: - Sends notification if requested
 TODO: - Implement saving of a course if have time
 TODO: - Implement filter of courses, tas, or instructor
 TODO: - Sort alphabetical, but have instructor's whose office hours are current at top
 TODO: - Don't forget to add some comments for future reference
 
 */
import UIKit
import CoreData

class IntroductionViewController: UIViewController {
    // TODO: - Implement Select Buttons for TA or Instructor
    
    
    let jsonParser = JsonParser()
    
    // fetch requests for specific data
    var fetchRequestTas: NSFetchRequest<TA>!
    var fetchRequestCourses: NSFetchRequest<Course>!
    var fetchRequestInstructors: NSFetchRequest<Instructor>!

    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // where we will get the data from
    let urlData = "https://api.jsonbin.io/b/5c0b24ae1deea01014bf4db9"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: - REMOVE THIS BEFORE SENDING IT IN
        deleteAllCoreData()

        downloadJSON(urlString: urlData)
        // Do any additional setup after loading the view.
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
    }
 
    
    // MARK: - Downloading JSON
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
            
            // fetches the instructor entities
            let fetchRequest: NSFetchRequest<Instructor> = Instructor.fetchRequest()
            var instHasCourse = Instructor(entity: instructorEntity, insertInto: managedObjectContext)
            
            // matches the course to its instructor using id matching
            // could be faster, i don't know how to implement that yet
            do {
                let instructors = try managedObjectContext.fetch(fetchRequest)
                for i in instructors {
                    if (i.inst_id == course.inst_id) {
                        instHasCourse = i
                    }
                }
            // error checks
            } catch {
                print("Could not fetch instructorEntity contents for courseObj: \(error)")
            }
            
            // relationship to instructor
            course.instructor = instHasCourse
            // adds the course as a relationship back to the instructor
            instHasCourse.addToCourses(course)
            
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
            var taHasCourse = Course(entity: courseEntity, insertInto: managedObjectContext)
            
            // matches the ta to its course
            do {
                let courses = try managedObjectContext.fetch(fetchRequest)
                
                for c in courses {
                    if (c.course_id == ta.course_id) {
                        taHasCourse = c
                    }
                }
            } catch {
                print("Could not fetch courseEntity contents for taObj: \(error)")
            }
            
            // relationship to course
            ta.course = taHasCourse
            // adds the ta back to the course
            taHasCourse.addToTas(ta)
        }
    }
    
    // shows the alert onscreen
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    func deleteAllCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let delAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Course"))
        
        do {
            try managedContext.execute(delAllReqVar)
        } catch {
            print(error)
        }
    }

}
