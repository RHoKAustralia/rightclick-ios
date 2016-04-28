//
//  LessonDetailViewController.swift
//  RightClickApp
//
//  Created by Janidu Wanigasuriya on 27/03/2016.
//  Copyright © 2016 Right Click. All rights reserved.
//

import UIKit
import Eureka

class LessonDetailViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "lesson-detail.form.title".localized
        
        addLessonDetailSection()
        addStudentDetailsSection()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    //MARK: Form building
    
    func addLessonDetailSection() {
        let section = Section("lesson-detail.form.section.lesson".localized)
        
        section.append(TextRow("LessonTitle") {
            $0.placeholder = "lesson-detail.form.placeholder.required".localized
            $0.title = "lesson-detail.form.lessonTitle".localized })
        
        section.append(TextRow("TutorName") {
            $0.placeholder = "lesson-detail.form.placeholder.required".localized
            $0.title = "lesson-detail.form.tutorName".localized })
        
        let deviceTypes = ["lesson-detail.form.deviceType.mobile".localized,
                           "lesson-detail.form.deviceType.tablet".localized,
                           "lesson-detail.form.deviceType.camera".localized,
                           "lesson-detail.form.deviceType.laptop".localized,
                           "lesson-detail.form.deviceType.other".localized]
        
        section.append(ActionSheetRow<String>("DeviceType") {
            $0.title = "lesson-detail.form.deviceType".localized
            $0.options = deviceTypes
            $0.value = deviceTypes.first })
        
        // Show this row only if Device type other is selected
        section.append(TextRow("DeviceTypeOther") {
            $0.placeholder = "lesson-detail.form.placeholder.required".localized
            $0.title = "lesson-detail.form.deviceTypeOther".localized
            $0.hidden = Condition.Function(["DeviceType"]) { form in
                if let r1 : ActionSheetRow<String> = form.rowByTag("DeviceType") {
                    return r1.value != "lesson-detail.form.deviceType.other".localized
                }
                return false
            }})
        
        form.append(section)
    }
    
    func addStudentDetailsSection() {
        let section = Section("lesson-detail.form.section.student".localized)
        
        section.append(TextRow("StudentName") {
            $0.placeholder = "lesson-detail.form.placeholder.required".localized
            $0.title = "lesson-detail.form.studentName".localized })
        section.append(EmailRow("StudentEmail") {
            $0.placeholder = "lesson-detail.form.placeholder.optional".localized
            $0.title = "lesson-detail.form.studentEmail".localized })
        
        form.append(section)
    }
    
    //MARK: Lesson
    
    func createLesson() -> Lesson {
        let formValues = form.values(includeHidden: true)
        
        // Lesson Details
        let lessonTitle = formValues["LessonTitle"] as? String ?? ""
        let tutorName = formValues["TutorName"] as? String ?? ""
        var deviceType = formValues["DeviceType"] as? String ?? ""
        
        // If device type is other use the value from the device type other
        if deviceType == "lesson-detail.form.deviceType.other".localized {
            deviceType = formValues["DeviceTypeOther"] as? String ?? ""
        }
        
        // Student details
        let studentName = formValues["StudentName"] as? String ?? ""
        let studentEmail = formValues["StudentEmail"] as? String
        
        let lesson = DataService.sharedInstance.createLesson(lessonTitle, tutorName: tutorName, deviceType: deviceType,
                                                studentName: studentName, studentEmail: studentEmail)
    
        return lesson
    }
    
    func validateLesson(lesson: Lesson) -> Bool {
        var valid = true
        var validationMessage = "lesson-detail.form.validation".localized
        
        if lesson.title.isEmpty {
            validationMessage = "\(validationMessage) \("lesson-detail.form.lessonTitle".localized)"
            valid = false
        } else if lesson.tutorName.isEmpty {
            validationMessage = "\(validationMessage) \("lesson-detail.form.tutorName".localized)"
            valid = false
        } else if lesson.studentName.isEmpty {
            validationMessage = "\(validationMessage) \("lesson-detail.form.studentName".localized)"
            valid = false
        } else if lesson.deviceType.isEmpty {
            validationMessage = "\(validationMessage) \("lesson-detail.form.deviceType".localized)"
            valid = false
        }
        
        if !valid {
            let validationAlert = UIAlertController(title: "alert.error.title".localized,
                                                    message: validationMessage, preferredStyle: .Alert)
            validationAlert.addAction(UIAlertAction(title: "alert.ok".localized,
                style: .Default, handler: nil))
            
            presentViewController(validationAlert, animated: true, completion: nil)
        }
        
        return valid
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let lesson = createLesson()
        validateLesson(lesson)
    }
}
