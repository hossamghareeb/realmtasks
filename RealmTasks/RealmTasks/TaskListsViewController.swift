//
//  TaskListsViewController.swift
//  RealmTasks
//
//  Created by Hossam Ghareeb on 10/13/15.
//  Copyright © 2015 Hossam Ghareeb. All rights reserved.
//

import UIKit
import RealmSwift

class TaskListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var currentCreateAction:UIAlertAction!
    @IBOutlet weak var taskListsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let lists = uiRealm.objects(TaskList)
        let tasks = uiRealm.objects(Task)
        
        print(lists)
        print(tasks)
        
//        let taskListA = TaskList()
//        taskListA.name = "Wishlist"
//        
//        let taskListB = TaskList(value: ["MoviesList", NSDate(), [["The Martian", NSDate(), "", false], ["The Maze Runner", NSDate(), "", true]]])
//        
//        
//        let wish1 = Task()
//        wish1.name = "iPhone6s"
//        wish1.notes = "64 GB, Gold"
//        
//        let wish2 = Task(value: ["name": "Game Console", "notes": "Playstation 4, 1 TB"])
//        let wish3 = Task(value: ["Car", NSDate(), "Auto R8", false])
//        
//        taskListA.tasks.appendContentsOf([wish1, wish2, wish3])
//        
//        uiRealm.write { () -> Void in
//            uiRealm.add([taskListA, taskListB])
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions -
    
    @IBAction func didClickOnEditButton(sender: UIBarButtonItem) {
    }
    
    @IBAction func didClickOnAddButton(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "New Tasks List", message: "Write the name of your tasks list.", preferredStyle: UIAlertControllerStyle.Alert)
        let createAction = UIAlertAction(title: "Create", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let listName = alertController.textFields?.first?.text
            print(listName)
        }
        
        alertController.addAction(createAction)
        createAction.enabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Task List Name"
            textField.addTarget(self, action: "listNameFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //Enable the create action of the alert only if textfield text is not empty
    func listNameFieldDidChange(textField:UITextField){
        self.currentCreateAction.enabled = textField.text?.characters.count > 0
    }
    
    // MARK: - UITableViewDataSource -
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("listCell")
        cell?.textLabel?.text = "List \(indexPath.row)"
        cell?.detailTextLabel?.text = "0 Tasks"
        return cell!
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
