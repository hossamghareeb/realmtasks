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

    @IBOutlet weak var tasksTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = selectedList.name
        completedTasks = self.selectedList.tasks.filter("isCompleted = true")
        openTasks = self.selectedList.tasks.filter("isCompleted = false")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
