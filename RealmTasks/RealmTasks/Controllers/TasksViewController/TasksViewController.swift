//
//  TasksViewController.swift
//  RealmTasks
//
//  Created by Hossam Ghareeb on 10/19/15.
//  Copyright © 2015 Hossam Ghareeb. All rights reserved.
//

import UIKit
import RealmSwift


class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedList : TaskList!
    var openTasks : Results<Task>!
    var completedTasks : Results<Task>!
    var currentCreateAction:UIAlertAction!
    
    var isEditingMode = false
    
    @IBOutlet weak var tasksTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = selectedList.name
        readTasksAndUpateUI()
    }
    
    // MARK: - User Actions -
    
    @IBAction func didClickOnEditTasks(sender: AnyObject) {
        isEditingMode = !isEditingMode
        self.tasksTableView.setEditing(isEditingMode, animated: true)
    }
    @IBAction func didClickOnNewTask(sender: AnyObject) {
        self.displayAlertToAddTask(nil)
    }
    func readTasksAndUpateUI(){
        
        completedTasks = self.selectedList.tasks.filter("isCompleted = true")
        openTasks = self.selectedList.tasks.filter("isCompleted = false")
        
        self.tasksTableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource -
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return openTasks.count
        }
        return completedTasks.count
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0{
            return "OPEN TASKS"
        }
        return "COMPLETED TASKS"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        var task: Task!
        if indexPath.section == 0{
            task = openTasks[indexPath.row]
        }
        else{
            task = completedTasks[indexPath.row]
        }
        
        cell?.textLabel?.text = task.name
        return cell!
    }
    
    
    func displayAlertToAddTask(updatedTask:Task!){
        
        var title = "New Task"
        var doneTitle = "Create"
        if updatedTask != nil{
            title = "Update Task"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Write the name of your task.", preferredStyle: UIAlertControllerStyle.Alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let taskName = alertController.textFields?.first?.text
            
            if updatedTask != nil{
                // update mode
                try! uiRealm.write{
                    updatedTask.name = taskName!
                    self.readTasksAndUpateUI()
                }
            }
            else{
                
                let newTask = Task()
                newTask.name = taskName!
                
                try! uiRealm.write{
                    
                    self.selectedList.tasks.append(newTask)
                    self.readTasksAndUpateUI()
                }
            }
            
            print(taskName)
        }
        
        alertController.addAction(createAction)
        createAction.enabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Task Name"
            textField.addTarget(self, action: #selector(TasksViewController.taskNameFieldDidChange(_:)) , forControlEvents: UIControlEvents.EditingChanged)
            if updatedTask != nil{
                textField.text = updatedTask.name
            }
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    //Enable the create action of the alert only if textfield text is not empty
    func taskNameFieldDidChange(textField:UITextField){
        self.currentCreateAction.enabled = textField.text?.characters.count > 0
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            //Deletion will go here
            
            var taskToBeDeleted: Task!
            if indexPath.section == 0{
                taskToBeDeleted = self.openTasks[indexPath.row]
            }
            else{
                taskToBeDeleted = self.completedTasks[indexPath.row]
            }
            
            try! uiRealm.write{
                uiRealm.delete(taskToBeDeleted)
                self.readTasksAndUpateUI()
            }
        }
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") { (editAction, indexPath) -> Void in
            
            // Editing will go here
            var taskToBeUpdated: Task!
            if indexPath.section == 0{
                taskToBeUpdated = self.openTasks[indexPath.row]
            }
            else{
                taskToBeUpdated = self.completedTasks[indexPath.row]
            }
            
            self.displayAlertToAddTask(taskToBeUpdated)
            
        }
        
        let doneAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Done") { (doneAction, indexPath) -> Void in
            // Editing will go here
            var taskToBeUpdated: Task!
            if indexPath.section == 0{
                taskToBeUpdated = self.openTasks[indexPath.row]
            }
            else{
                taskToBeUpdated = self.completedTasks[indexPath.row]
            }
            try! uiRealm.write{
                taskToBeUpdated.isCompleted = true
                self.readTasksAndUpateUI()
            }
            
        }
        return [deleteAction, editAction, doneAction]
    }


}
