//
//  TasksListViewModel.swift
//  RealmTasks
//
//  Created by Hossam Ghareeb on 10/6/16.
//  Copyright © 2016 Hossam Ghareeb. All rights reserved.
//

import UIKit
import RealmSwift

class TasksListViewModel: TasksListViewModelProtocol {

    var tasksList: [TaskList] = []
    
    var newListName: String = ""
    
    var newListNameIsValid: Bool{
        get{
            return newListName.characters.count > 0
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
    
    private var lists : Results<TaskList>!
    
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
}
