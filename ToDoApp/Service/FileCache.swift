//
//  FileCache.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 17.06.2024.
//

import Foundation

final class FileCache {
    // MARK: Properties
    private(set) var todoItems = [String: TodoItem]()
    private let fileManager = FileManager.default
    private var path: URL?
    
    // MARK: Functions
    func addNewTask(_ toDoItem: TodoItem) {
        if todoItems[toDoItem.id] != nil {
            print("id duplicate")
            return
            
        }
        todoItems[toDoItem.id] = toDoItem
    }
    
    func delTask(id: String) {
        todoItems[id] = nil
    }
    
    func fetchTodoItems(from fileName: String = "default.json") {
        guard let sourcePath = getSourcePath(with: fileName) else {
            return
        }
        
        if fileManager.fileExists(atPath: sourcePath.path()) {
            do {
                let jsons = try Data(contentsOf: sourcePath, options: .mappedIfSafe)
                
                guard let dictionary = try JSONSerialization.jsonObject(with: jsons) as? [Dictionary<String, Any>] else {
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
    
    func saveTodoItems(to fileName: String = "default.json") {
        guard let sourcePath = getSourcePath(with: fileName) else { return }
        
        let todoItemsJsons = todoItems.compactMap { $0.value.json }
        
        do {
            let json = try JSONSerialization.data(withJSONObject: todoItemsJsons)
            try json.write(to: sourcePath, options: [])
        } catch {
            assertionFailure("saveTodoItems(to fileName: String?) - error writing to the file: \(error.localizedDescription)")
            return
        }
    }
    
    // MARK: Private Functions
    private func createSourcePath() {
        guard var documents = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            print("getSourcePath(with fileName: String?) - error creating the source path")
            return
        }
        documents.append(path: "JsonStorage")
        
        do {
            try fileManager.createDirectory(
                at: documents,
                withIntermediateDirectories: true)
        } catch {
            print("getSourcePath(with fileName: String?) - error creating the JsonStorage dir: \(error.localizedDescription)")
        }
        
        path = documents
    }
    
    private func getSourcePath(with fileName: String = "default.json") -> URL? {
        if path == nil { createSourcePath() }
        guard var sourcePath = path else { return nil }
        
        
        sourcePath.append(path: fileName)

        return sourcePath
    }
}
