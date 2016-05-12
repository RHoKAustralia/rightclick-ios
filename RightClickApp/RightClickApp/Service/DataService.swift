//
//  DataService.swift
//  RightClickApp
//
//  Created by Janidu Wanigasuriya on 17/04/2016.
//  Copyright © 2016 Right Click. All rights reserved.
//

import Foundation

class DataService {
    
    static let sharedInstance = DataService()
    private var lesson: Lesson?
    
    func createLesson(title: String, tutorName: String, deviceType: String,
                      studentName: String, studentEmail: String?) -> Lesson {
        // Create a lesson
        lesson = Lesson(title: title, tutorName: tutorName, deviceType: deviceType,
                        studentName: studentName, studentEmail: studentEmail, notes: [Note]())
        
        return lesson!
    }
    
    func createNote(noteText: String, noteImagePath: String) -> Note {
        let note = Note(noteText: noteText, noteImage: nil, noteImagePath: noteImagePath)
        lesson?.notes.append(note)
        return note
    }
}
