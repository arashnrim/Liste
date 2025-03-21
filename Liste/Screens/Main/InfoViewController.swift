//
//  InfoViewController.swift
//  Liste
//
//  Created by Arash on 29/08/20.
//  Copyright © 2020 Apprendre. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var taskDescriptionView: UITextView!
    @IBOutlet weak var taskDueLabel: UILabel!

    // MARK: Properties
    var tasks: [Task] = []
    var task: Task?
    var row: Int?

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Reads the data of the task and loads them.
        if let task = task {
            let name = task.taskName
            let description = task.description
            let dueDate = self.convertDateToString(date: task.dueDate)

            self.taskNameField.text = name

            if description != "" {
                self.taskDescriptionView.text = description
            } else {
                self.taskDescriptionView.text = NSLocalizedString("noDescription", comment: "No description provided.")
                self.taskDescriptionView.textColor = .lightGray
            }

            self.taskDueLabel.text = dueDate
            // Gets and compares the current date with the task's due date.
            // If the current date is later than or exactly the due date, the date will be highlighted to indicate that the task is overdue.
            let date = Date()
            if task.dueDate <= date {
                self.taskDueLabel.textColor = UIColor(named: "Liste Orange")
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            let destination = segue.destination as! AddViewController
            destination.tasks = tasks
            destination.task = task
            destination.row = row
        } else if segue.identifier == "focus" {
            let destination = segue.destination as! FMInitialisationViewController
            destination.tasks = tasks
            destination.task = task
            destination.row = row
        }
    }

    // MARK: Actions
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
