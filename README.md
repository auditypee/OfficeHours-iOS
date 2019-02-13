# OfficeHours-iOS
Uses Core Data instead of Plist

The purpose of this project was to utilize CoreData in populating a table. Data was taken from a [json file](https://api.jsonbin.io/b/5c11f7aeec62650f24de6ea5) that contained Instructors' and Teaching Assistants' information and office hours. 

Each Table Cell shows some details about the person. The courses they are teaching, the rooms where they are holding office hours, and their current availability -- if they are holding office hours in the current time or not. Swiping left on an instructor or TA allows the user to favorite that person's course. This persists between the two different table views because courses are shared between the TA and the instructor. So far, favorite does nothing except add a little marking on the top right indicating whether that TA or instructor has a favorited course.

Tapping on an instructor or teaching assistant leads the user to more information about that person's classes and office hours time. 

```
TODO: - Sends notification if requested
TODO: - Implement filter of courses that have been favorited
```
