//
//  TasksListViewModel.swift
//  RealmTasks
//
//  Created by Hossam Ghareeb on 10/6/16.
//  Copyright © 2016 Hossam Ghareeb. All rights reserved.
//

import UIKit
import RealmSwift

class TasksListViewModel: NSObject, TasksListViewModelProtocol{

    dynamic var tasksList: [TaskList] = []
    
    var newListName: String = ""{
        didSet{
            self.newListNameIsValid = newListName.characters.count > 0
        }
    }
    
    dynamic var isEditingMode: Bool = false
    
    dynamic var newListNameIsValid: Bool = false
    
    var listsCount: Int{
        get{
            return self.tasksList.count
        }
    }
    
    
    var listToBeUpdated: TaskList?
    
    var popupNewOrEditListDoneString: String{
        get{
            if self.listToBeUpdated != nil{
                return "Update"
            }
            return "Create"
        }
    }
    
    var popupNewOrEditListTitleString: String{
        get{
            if self.listToBeUpdated != nil{
                return "Update Tasks List"
            }
            return "New Tasks List"
        }
    }
    var popupNewOrEditListMessageString: String{
        get{
            return "Write the name of your tasks list."
        }
    }
    var popupNewOrEditListCancelString: String{
        get{
            return "Cancel"
        }
    }
    var popupNewOrEditListFieldPlaceholderString: String{
        get{
            return "Task List Name"
        }
    }
    var deleteListTitle: String{
        get{
            return "Delete"
        }
    }
    
    var editListTitle: String{
        get{
            return "Edit"
        }
    }
    
    private var lists : Results<TaskList>!
    
    func startUpdateListAtIndex(index: Int) {
        self.listToBeUpdated = nil
        self.newListName = ""
        if index >= 0 && index < self.listsCount {
            let list = self.tasksList[index]
            self.newListName = list.name
            self.listToBeUpdated = list
        }
    }
    
    func listAtIndex(index: Int) -> TaskList? {
        if index >= 0 && index < self.listsCount {
            return self.tasksList[index]
        }
        return nil
    }
    
    func toggleEditMode() {
        self.isEditingMode = !self.isEditingMode
    }
    
    func loadTaskLists() {
        self.lists = uiRealm.objects(TaskList)
        self.tasksList = Array(self.lists)
    }
    
    func sortBy(sortCriteria: TasksListSortCriteria) {
        switch sortCriteria {
        case .createdAt:
            self.tasksList = Array(self.lists.sorted("createdAt", ascending:false))
        case .name:
            self.tasksList = Array(self.lists.sorted("name"))
        }
    }
    
    func deleteListAtIndex(index: Int) {
        let listToBeDeleted = self.tasksList[index]
        try! uiRealm.write{
            
            uiRealm.delete(listToBeDeleted)
            self.loadTaskLists()
        }
    }
    
    func didFinishAddingOrUpdatingList() {
        if let updatedList = self.listToBeUpdated{
            // update mode
            try! uiRealm.write{
                updatedList.name = self.newListName
                self.loadTaskLists()
            }
        }
        else{
            
            let newTaskList = TaskList()
            newTaskList.name = self.newListName
            
            try! uiRealm.write{
                
                uiRealm.add(newTaskList)
                self.loadTaskLists()
            }
        }
    }
    
    func listNameAtIndex(index: Int) -> String {
        if index >= 0 && index < self.listsCount {
            let list = self.tasksList[index]
            return list.name
        }
        return ""
    }
    func listDetailsTextAtIndex(index: Int) -> String {
        if index >= 0 && index < self.listsCount {
            let list = self.tasksList[index]
            return "\(list.tasks.count) Tasks"
        }
        return ""
    }
}
