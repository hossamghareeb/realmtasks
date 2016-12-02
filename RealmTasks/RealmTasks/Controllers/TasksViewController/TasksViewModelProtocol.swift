//
//  TasksViewModelProtocol.swift
//  RealmTasks
//
//  Created by Hossam Ghareeb on 10/10/16.
//  Copyright © 2016 Hossam Ghareeb. All rights reserved.
//

import UIKit

protocol TasksViewModelProtocol {

    var selectedList: AnyObject? {get set}
    var listName: String {get}
    var isEditingMode: Bool {get set}
    var tasksDidChange: Bool {get}
    
    var numberOfOpenTasks: Int {get}
    var numberOfCompletedTasks: Int {get}
    
    var numberOfSections: Int{get}
    
    var newTaskName: String {get set}
    var taskNameIsValid: Bool {get}
    
    func titleForOpenTaskAtIndex(index: Int) -> String
    func titleForCompletedTaskAtIndex(index: Int) -> String
    
    func filterTasks()
    
    func toggleEditMode()
    
    var alertTitleForEditingTask: String {get}
    var alertDoneTiteForEditingTask: String {get}
    var alertMessageForEditingTask: String {get}
    
    func titleForSection(section: Int) -> String
    
    func deleteOpenTaskAtIndex(index: Int)
    func deleteCompletedTaskAtIndex(index: Int)
    
    func markOpenTaskAsDoneAtIndex(index: Int)
    
    
    func startUpdateOpenTaskAtIndex(index: Int) 
    func startUpdateCompletedTaskAtIndex(index: Int)
    
    func didFinishAddingOrUpdatingTask()
}
