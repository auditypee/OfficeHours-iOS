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
 
 
 
 
 */
import UIKit
import CoreData

class IntroductionViewController: UIViewController {
    // TODO: - Implement Select Buttons for TA or Instructor
    
    
    let jsonParser = JsonParser()
    
    // fetch requests for specific data
    //var fetchRequestTas: NSFetchRequest<TA>!
    //var fetchRequestCourses: NSFetchRequest<Course>!
    var fetchRequestInstructors: NSFetchRequest<Instructor>!

    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    // where we will get the data from
    let urlData = "https://api.jsonbin.io/b/5c05ffe613c72a101ab2ff22"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    func downloadJsonDataIfNeeded() {
        fetchRequestCourses = Course.fetchRequest()
        fetchRequestTas = TA.fetchRequest()
        fetchRequestInstructors = Instructor.fetchRequest()
        
        let countCourses = try! self.managedObjectContext?.count(for: fetchRequestCourses)
        let countTas = try! self.managedObjectContext?.count(for: fetchRequestTas)
        let countInstructors = try! self.managedObjectContext?.count(for: fetchRequestInstructors)
        
        // check if of the results are empty
        guard countCourses == 0 || countTas == 0 || countInstructors == 0 else {
            print("None found")
            return
        }
        do {
            let results = try self.managedObjectContext?.fetch(fetchRequestCourses)
        } catch {
            print("Error: Fetching", error)
        }
        
    }
    */
    /*
     Downloads JSON data from a URL
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
                let courseEntity = NSEntityDescription.entity(forEntityName: "Course", in: self.managedObjectContext)!
                
                let courseObjects = self.jsonParser.extractCourses(data: data)
                
                for c in courseObjects {
                    let course = Course(entity: courseEntity, insertInto: self.managedObjectContext)
                    course.course_name = c.name
                    course.course_hours = c.hours
                    course.course_room = c.room
                    course.course_num = c.num
                    course.course_days = c.days
                    
                    course.ta = nil
                    course.instructor = nil
                }
                
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
