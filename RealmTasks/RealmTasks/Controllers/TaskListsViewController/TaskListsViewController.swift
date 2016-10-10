//
//  TaskListsViewController.swift
//  RealmTasks
//
//  Created by Hossam Ghareeb on 10/13/15.
//  Copyright © 2015 Hossam Ghareeb. All rights reserved.
//

import UIKit
import KVOController

class TaskListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var isEditingMode = false
    
    var currentCreateAction:UIAlertAction!
    
    var viewModel: TasksListViewModelProtocol?
    
    @IBOutlet weak var taskListsTableView: UITableView!
    
    override func viewDidLoad() {
        setUpViewModel()
    }
    
    func setUpViewModel(){
        
        self.viewModel = TasksListViewModel()
        
        self.KVOController.observe(self.viewModel as? AnyObject, keyPath: "tasksList", options: [.New, .Initial]) { (viewController, viewModel, change) in
            
            self.taskListsTableView.reloadData()
        }
        
        self.KVOController.observe(self.viewModel as? AnyObject, keyPath: "isEditingMode", options: [.Initial, .New]) { (viewController, viewModel, change) in
            
            if let isEdit = change[NSKeyValueChangeNewKey] as? Bool{
                self.taskListsTableView.setEditing(isEdit, animated: true)
            }
        }
        
        self.KVOController.observe(self.viewModel as? AnyObject, keyPath: "newListNameIsValid", options: [.Initial, .New]) { (viewController, viewModel, change) in
            
            if let nameIsValid = change[NSKeyValueChangeNewKey] as? Bool, let action = self.currentCreateAction{
                action.enabled = nameIsValid
            }
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        readTasksAndUpdateUI()
    }
    
    func readTasksAndUpdateUI(){
        self.viewModel!.loadTaskLists()
    }
    
    // MARK: - User Actions -
    
    @IBAction func didSelectSortCriteria(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            self.viewModel!.sortBy(.name)
        }
        else{
            // date
            self.viewModel!.sortBy(.createdAt)
        }
    }
    
    @IBAction func didClickOnEditButton(sender: UIBarButtonItem) {
        self.viewModel?.toggleEditMode()
    }
    
    @IBAction func didClickOnAddButton(sender: UIBarButtonItem) {
        
        displayAlertToAddTaskList(-1)
    }
    
    //Enable the create action of the alert only if textfield text is not empty
    func listNameFieldDidChange(textField:UITextField){
        self.viewModel?.newListName = textField.text!
    }
    
    func displayAlertToAddTaskList(listIndex:Int){
        
        self.viewModel?.startUpdateListAtIndex(listIndex)
        let title = self.viewModel?.popupNewOrEditListTitleString
        let doneTitle = self.viewModel?.popupNewOrEditListDoneString
        
        let alertController = UIAlertController(title: title, message: self.viewModel?.popupNewOrEditListMessageString, preferredStyle: UIAlertControllerStyle.Alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.Default) { (action) -> Void in
            
            self.viewModel?.didFinishAddingOrUpdatingList()
        }
        
        alertController.addAction(createAction)
        createAction.enabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: self.viewModel?.popupNewOrEditListCancelString, style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = self.viewModel?.popupNewOrEditListFieldPlaceholderString
            textField.addTarget(self, action: #selector(TaskListsViewController.listNameFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
            
            textField.text = self.viewModel?.newListName
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource -
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel!.listsCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("listCell")
        
        cell?.textLabel?.text = self.viewModel?.listNameAtIndex(indexPath.row)
        cell?.detailTextLabel?.text = self.viewModel?.listDetailsTextAtIndex(indexPath.row)
        return cell!
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: self.viewModel!.deleteListTitle) { (deleteAction, indexPath) -> Void in
            
            //Deletion will go here
            
            self.viewModel?.deleteListAtIndex(indexPath.row)
        }
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: self.viewModel!.editListTitle) { (editAction, indexPath) -> Void in
            
            // Editing will go here
            self.displayAlertToAddTaskList(indexPath.row)
            
        }
        return [deleteAction, editAction]
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("openTasks", sender: self.viewModel?.listAtIndex(indexPath.row))
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let tasksViewController = segue.destinationViewController as! TasksViewController
        tasksViewController.selectedList = sender as! TaskList
    }

}
