//
//  AddViewController.swift
//  Liste
//
//  Created by Arash on 31/07/20.
//  Copyright © 2020 Apprendre. All rights reserved.
//

import UIKit
import Firebase

/**
 * All code regarding UI elements of the Add View Controller resides here.
 *
 * To view the declaration of code functions interacting with the database, view `AddViewController+Database.swift`.
 *
 * - See also: AddViewController+Database.swift
 */
class AddViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    // MARK: Outlets
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var taskDescriptionView: UITextView!
    @IBOutlet weak var taskDuePicker: UIDatePicker!

    // MARK: Properties
    var tasks: [Task] = []
    // The task and row variable below is used only for editing; in both instances, the full list of tasks are used.
    var task: Task?
    var row: Int?

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Sets the delegate of the text fields as AddViewController.
        self.taskNameField.delegate = self
        self.taskDescriptionView.delegate = self

        // Manually sets a placeholder in taskDescriptionView.
        taskDescriptionView.text = "Task description"
        taskDescriptionView.textColor = UIColor.lightGray

        // Allows editing to end when any part of the screen is tapped outside the keyboard area.
        self.dismissKeyboardOnTap(completion: nil)
        
        // If the task variable is not nil, then it's likely because the user wants to edit a task. In that case, the task's details are listed here.
        if let task = task {
            self.taskNameField.text = task.taskName
            self.taskDescriptionView.text = task.description
            self.taskDescriptionView.textColor = .black
            self.taskDuePicker.date = task.dueDate
        }
    }

    // MARK: Text Field Protocols
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == taskNameField {
            self.taskNameField.resignFirstResponder()
            self.taskDescriptionView.becomeFirstResponder()
        }
        return false
    }

    // MARK: Text View Protocols
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Task description"
            textView.textColor = UIColor.lightGray
        }
    }

    // MARK: Actions
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        let isValid = validateInputs()

        if isValid {
            if let row = row {
                tasks.remove(at: row)
            }
            tasks.append(prepareTask())
            let jsonTasks = self.convertTaskToJSON(tasks: tasks)
            self.updateDatabase(tasks: jsonTasks) {
                self.performSegue(withIdentifier: "dismiss", sender: nil)
            }
        } else {
            self.displayAlert(title: "Whoops!", message: "Some fields are invalid. Please take a look at your fields and try again.", override: nil)
        }
    }

    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.displayAlert(title: "Wait!", message: "Are you sure to dismiss all written data? This action cannot be recovered.") { (alert) in
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.show(alert, sender: nil)
        }
    }
}
