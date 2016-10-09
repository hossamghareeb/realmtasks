//
//  TasksListViewModelProtocol.swift
//  RealmTasks
//
//  Created by Hossam Ghareeb on 10/6/16.
//  Copyright © 2016 Hossam Ghareeb. All rights reserved.
//

import UIKit

enum TasksListSortCriteria {
    case name
    case createdAt
}

protocol TasksListViewModelProtocol{

    var tasksList: [TaskList] {get}
    
    var newListName: String {set get}
    
    var newListNameIsValid: Bool {get}
    
    var listToBeUpdated: TaskList? {get}
    
    func loadTaskLists()
    func sortBy(sortCriteria: TasksListSortCriteria)
    
    var popupNewOrEditListTitleString: String {get}
    var popupNewOrEditListDoneString: String {get}
    var popupNewOrEditListMessageString: String {get}
}
