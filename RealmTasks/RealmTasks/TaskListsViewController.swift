//
//  TaskListsViewController.swift
//  RealmTasks
//
//  Created by Hossam Ghareeb on 10/13/15.
//  Copyright © 2015 Hossam Ghareeb. All rights reserved.
//

import UIKit

class TaskListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var taskListsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Actions -
    
    @IBAction func didClickOnEditButton(sender: UIBarButtonItem) {
    }
    
    @IBAction func didClickOnAddButton(sender: UIBarButtonItem) {
    }
    
    // MARK: - UITableViewDataSource -
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
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
