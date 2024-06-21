//
//  FileCache.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 17.06.2024.
//

import Foundation

final class FileCache {
//    MARK: Properties
    private(set) var todoItems: [TodoItem]?
    private let fileManager = FileManager.default
    
//    MARK: Functions
    func addNewTask(_ toDoItem: TodoItem) {
        if todoItems == nil {
            todoItems = [TodoItem]()
        }
        
        todoItems?.forEach { item in
            if item.id == toDoItem.id {
                assertionFailure("id duplicate")
                return
            }
        }
        
        todoItems?.append(toDoItem)
    }
    
    func delTask(id: String) {
        todoItems?.removeAll(where: { $0.id == id })
    }
    
//  guard let json = json as? Data else { return nil }
//
    func fetchTodoItems(from fileName: String?) {
        guard let sourcePath = getSourcePath(with: fileName) else {
            return
        }
        
        if fileManager.fileExists(atPath: sourcePath.path()) {
            do {
                let jsons = try Data(contentsOf: sourcePath, options: .mappedIfSafe)
                
                guard let dictionary = try JSONSerialization.jsonObject(with: jsons) as? [Dictionary<String, String>] else {
                    assertionFailure("fetchTodoItems() dictionary creation error")
                    return
                }
                
                for items in dictionary {
                    guard let item = TodoItem.parse(json: items) else { 
                        assertionFailure("fetchTodoItems() - parse error")
                        return
                    }
                    addNewTask(item)
                }
                
            } catch {
                assertionFailure("fetchTodoItems() - \(error.localizedDescription)")
            }
        } else {
            print("fetchTodoItems() - not exist")
        }
    }
    
    func saveTodoItems(to fileName: String?) {
        guard let todoItems else {
            print("saveTodoItems(to fileName: String?) - todoItems is empty")
            return
        }
        guard let sourcePath = getSourcePath(with: fileName) else { return }
        
        let todoItemsJsons = todoItems.map { $0.json }
        
        do {
            let json = try JSONSerialization.data(withJSONObject: todoItemsJsons)
            try json.write(to: sourcePath, options: [])
        } catch {
            assertionFailure("saveTodoItems(to fileName: String?) - error writing to the file: \(error.localizedDescription)")
            return
        }
    }
    
//    MARK: Private Functions
    private func getSourcePath(with fileName: String?) -> URL? {
        guard var sourcePath = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            assertionFailure("getSourcePath(with fileName: String?) - error creating the source path")
            return nil
        }
        
        sourcePath.append(path: "JsonStorage")
        
        if !sourcePath.hasDirectoryPath {
            do {
                try fileManager.createDirectory(
                    at: sourcePath,
                    withIntermediateDirectories: true)
            } catch {
                assertionFailure("getSourcePath(with fileName: String?) - error creating the JsonStorage dir: \(error.localizedDescription)")
            }
        }
        
        if let fileName {
            sourcePath.append(path: fileName)
        } else {
            sourcePath.append(path: "default.json")
        }
        
        return sourcePath
    }
}
