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

    var currentCreateAction:UIAlertAction!
    
    var viewModel: TasksViewModelProtocol = TasksViewModel()
    
    @IBOutlet weak var tasksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.filterTasks()
        
        setUpViewModel()
    }
    
    func setUpViewModel(){
        
        self.KVOController.observe(self.viewModel as? AnyObject, keyPath: "listName", options: [.New, .Initial]) { (viewController, viewModel, change) in
            
            if let newName = change[NSKeyValueChangeNewKey] as? String{
                self.title = newName
            }
        }
        
        self.KVOController.observe(self.viewModel as? AnyObject, keyPath: "tasksDidChange", options: [.Initial, .New]) { (viewController, viewModel, change) in
            
            self.tasksTableView.reloadData()
        }
        self.KVOController.observe(self.viewModel as? AnyObject, keyPath: "isEditingMode", options: [.Initial, .New]) { (viewController, viewModel, change) in
            
            if let isEdit = change[NSKeyValueChangeNewKey] as? Bool{
                self.tasksTableView.setEditing(isEdit, animated: true)
            }
        }
        
        self.KVOController.observe(self.viewModel as? AnyObject, keyPath: "taskNameIsValid", options: [.Initial, .New]) { (viewController, viewModel, change) in
            
            if let nameIsValid = change[NSKeyValueChangeNewKey] as? Bool, let action = self.currentCreateAction{
                action.enabled = nameIsValid
            }
        }
    }
    
    // MARK: - User Actions -
    
    @IBAction func didClickOnEditTasks(sender: AnyObject) {
        self.viewModel.toggleEditMode()
    }
    
    @IBAction func didClickOnNewTask(sender: AnyObject) {
        self.displayAlertToAddOrUpdateTask()
    }
    
    // MARK: - UITableViewDataSource -
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return viewModel.numberOfOpenTasks
        }
        return viewModel.numberOfCompletedTasks
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        var taskName: String = ""
        if indexPath.section == 0{
            taskName = self.viewModel.titleForOpenTaskAtIndex(indexPath.row)
        }
        else{
            taskName = self.viewModel.titleForCompletedTaskAtIndex(indexPath.row)
        }
        cell?.textLabel?.text = taskName
        return cell!
    }
    
    
    func displayAlertToAddOrUpdateTask(){
        
        let alertController = UIAlertController(title: self.viewModel.alertTitleForEditingTask, message: self.viewModel.alertMessageForEditingTask, preferredStyle: UIAlertControllerStyle.Alert)
        let createAction = UIAlertAction(title: self.viewModel.alertDoneTiteForEditingTask, style: UIAlertActionStyle.Default) { (action) -> Void in
            
            self.viewModel.didFinishAddingOrUpdatingTask()
        }
        
        alertController.addAction(createAction)
        createAction.enabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Task Name"
            textField.addTarget(self, action: #selector(TasksViewController.taskNameFieldDidChange(_:)) , forControlEvents: UIControlEvents.EditingChanged)
            textField.text = self.viewModel.newTaskName
            
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    //Enable the create action of the alert only if textfield text is not empty
    func taskNameFieldDidChange(textField:UITextField){
        self.viewModel.newTaskName = textField.text!
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            if indexPath.section == 0{
                self.viewModel.deleteOpenTaskAtIndex(indexPath.row)
            }
            else{
                self.viewModel.deleteCompletedTaskAtIndex(indexPath.row)
            }
        }
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") { (editAction, indexPath) -> Void in
            
            // Editing will go here
            if indexPath.section == 0{
                self.viewModel.startUpdateOpenTaskAtIndex(indexPath.row)
            }
            else{
                self.viewModel.startUpdateOpenTaskAtIndex(indexPath.row)
            }
            
            self.displayAlertToAddOrUpdateTask()
        }
        
        let doneAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Done") { (doneAction, indexPath) -> Void in
            // Editing will go here
            if indexPath.section == 0{
                self.viewModel.markOpenTaskAsDoneAtIndex(indexPath.row)
            }
        }
        return indexPath.section == 0 ? [deleteAction, editAction, doneAction] : [deleteAction, editAction]
    }
}
