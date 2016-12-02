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
    
    var listsDidChange: Bool {get}
    
    var newListName: String {set get}
    
    var newListNameIsValid: Bool {get}
    
    var isEditingMode: Bool {get set}
    
    var listsCount: Int {get}
    
    func toggleEditMode()
    
    func listAtIndex(index: Int) -> AnyObject?
    
    func loadTaskLists()
    func sortBy(sortCriteria: TasksListSortCriteria)
    func listNameAtIndex(index: Int) -> String
    func listDetailsTextAtIndex(index: Int) -> String
    func deleteListAtIndex(index: Int)
    func startUpdateListAtIndex(index: Int)
    func didFinishAddingOrUpdatingList()
    
    var popupNewOrEditListTitleString: String {get}
    var popupNewOrEditListDoneString: String {get}
    var popupNewOrEditListCancelString: String {get}
    var popupNewOrEditListMessageString: String {get}
    var popupNewOrEditListFieldPlaceholderString: String {get}
    var deleteListTitle: String {get}
    var editListTitle: String {get}
}
