//
//  TasksViewModel.swift
//  RealmTasks
//
//  Created by Hossam Ghareeb on 10/10/16.
//  Copyright © 2016 Hossam Ghareeb. All rights reserved.
//

import UIKit
import RealmSwift

class TasksViewModel: NSObject, TasksViewModelProtocol{
    
    private var openTasks : Results<Task>!{
        didSet{
            tasksDidChange = true
        }
    }
    private var completedTasks : Results<Task>!{
        didSet{
            tasksDidChange = true
        }
    }
    
    private var taskToBeUpdated: Task!
    
    var newTaskName: String = "" {
        didSet{
            self.taskNameIsValid = newTaskName.characters.count > 0
        }
    }
    
    dynamic var taskNameIsValid: Bool = false
    
    var numberOfOpenTasks: Int{
        get{
            return self.openTasks.count
        }
    }
    var numberOfCompletedTasks: Int{
        get{
            return self.completedTasks.count
        }
    }
    var numberOfSections = 2
    
    dynamic var tasksDidChange: Bool = false
    dynamic var isEditingMode: Bool = false

    var selectedList: AnyObject?{
        didSet{
            self.currentSelectedList = self.selectedList as? TaskList
        }
    }
    private var currentSelectedList: TaskList?{
        didSet{
            if let list = self.currentSelectedList{
                self.listName = list.name
            }
        }
    }
    dynamic var listName: String = ""
    
    var alertTitleForEditingTask: String{
        get{
            return self.taskToBeUpdated == nil ? "New Task" : "Update Task"
        }
    }
    var alertDoneTiteForEditingTask: String{
        get{
            return self.taskToBeUpdated == nil ? "Create" : "Update"
        }
    }
    var alertMessageForEditingTask: String{
        get{
            return "Write the name of your task."
        }
    }
    
    func filterTasks(){
        
        if let list = self.currentSelectedList{
            completedTasks = list.tasks.filter("isCompleted = true")
            openTasks = list.tasks.filter("isCompleted = false")
        }
    }
    
    func toggleEditMode() {
        self.isEditingMode = !self.isEditingMode
    }
    
    func titleForSection(section: Int) -> String {
        if section == 0{
            return "OPEN TASKS"
        }
        return "COMPLETED TASKS"
    }
    
    func titleForOpenTaskAtIndex(index: Int) -> String{
        if index >= 0 && index < self.openTasks.count{
            let task = self.openTasks[index]
            return task.name
        }
        return ""
    }
    func titleForCompletedTaskAtIndex(index: Int) -> String{
        if index >= 0 && index < self.completedTasks.count{
            let task = self.completedTasks[index]
            return task.name
        }
        return ""
    }
    
    func deleteOpenTaskAtIndex(index: Int) {
        
        if index >= 0 && index < self.openTasks.count {
            let taskToBeDeleted = self.openTasks[index]
            deleteTask(taskToBeDeleted)
        }
    }
    
    func deleteCompletedTaskAtIndex(index: Int) {
        if index >= 0 && index < self.completedTasks.count {
            let taskToBeDeleted = self.completedTasks[index]
            deleteTask(taskToBeDeleted)
        }
    }
    
    func markOpenTaskAsDoneAtIndex(index: Int) {
        if index >= 0 && index < self.openTasks.count {
            let taskToBeDone = self.openTasks[index]
            try! uiRealm.write{
                taskToBeDone.isCompleted = true
                filterTasks()
            }
        }
    }
    
    func startUpdateOpenTaskAtIndex(index: Int) {
        self.taskToBeUpdated = nil
        self.newTaskName = ""
        if index >= 0 && index < self.openTasks.count {
            let task = self.openTasks[index]
            self.taskToBeUpdated = task
            self.newTaskName = task.name
        }
    }
    func startUpdateCompletedTaskAtIndex(index: Int) {
        self.taskToBeUpdated = nil
        self.newTaskName = ""
        if index >= 0 && index < self.completedTasks.count {
            let task = self.completedTasks[index]
            self.taskToBeUpdated = task
            self.newTaskName = task.name
        }
    }
    
    func didFinishAddingOrUpdatingTask(){
        
        if let updatedTask = self.taskToBeUpdated{
            try! uiRealm.write{
                updatedTask.name = self.newTaskName
            }
        }
        else{
            
            let newTask = Task()
            newTask.name = self.newTaskName
            
            try! uiRealm.write{
                if let list = self.selectedList as? TaskList{
                    list.tasks.append(newTask)
                }
            }
        }
        self.filterTasks()
    }
    
    private func deleteTask(task: Task){
        try! uiRealm.write{
            uiRealm.delete(task)
            filterTasks()
        }
    }
}
