//
//  FileCache.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 25.07.2024.
//

import Foundation
import SwiftData
import SwiftUI

final class FileCache<T: FileCacheItem>: ObservableObject {
    // MARK: Properties
    var swiftDataItems: [SwiftDataItem] = []
    @Published var todosSwiftData: [TodoItem] = []
    @Published var error: Error?
    @Published var showCompletedTasks = false
    var filteredTasks: [TodoItem] {
        todosSwiftData.filter { showCompletedTasks || !$0.isDone }
    }

    var todoItems = [String: T]()
    let fileManager = FileManager.default
    var path: URL?
    var modelContainer: ModelContainer?
    var modelContext: ModelContext?

    // MARK: Initialiser
    @MainActor
    init() {
        do {
            let container = try ModelContainer(for: SwiftDataItem.self)
            self.modelContainer = container
            self.modelContext = container.mainContext
            modelContext?.autosaveEnabled = true

            fetch()
        } catch {
            print(error)
            print(error.localizedDescription)
            self.error = error
        }
    }

    // MARK: Functions
    func addNewTask(
        _ toDoItem: T
    ) {
        if todoItems[toDoItem.id] != nil {
            todoItems[toDoItem.id] = nil
        }
        todoItems[toDoItem.id] = toDoItem
    }

    @discardableResult
    func deleteTask(
        id: String
    ) -> T? {
        return todoItems.removeValue(
            forKey: id
        )
    }

    func fetchTodoItems(
        from fileName: String = "default.json"
    ) {
        guard let sourcePath = getSourcePath(
            with: fileName
        ) else {
            return
        }

        if fileManager.fileExists(
            atPath: sourcePath.path()
        ) {
            do {
                let jsons = try Data(
                    contentsOf: sourcePath,
                    options: .mappedIfSafe
                )

                guard let dictionary = try JSONSerialization.jsonObject(
                    with: jsons
                ) as? [Dictionary<
                       String,
                       Any
                       >] else {
                    print(
                        "fetchTodoItems() dictionary creation error"
                    )
                    return
                }

                todoItems = [String: T]()
                for items in dictionary {
                    guard let item = T.parse(
                        json: items
                    ) else {
                        print(
                            "fetchTodoItems() - parse error"
                        )
                        continue
                    }
                    addNewTask(
                        item
                    )
                }

            } catch {
                print(
                    "fetchTodoItems() - \(error.localizedDescription)"
                )
            }
        } else {
            print(
                "fetchTodoItems() - not exist"
            )
        }
    }

    func saveTodoItems(
        to fileName: String = "default.json"
    ) {
        guard let sourcePath = getSourcePath(
            with: fileName
        ) else {
            return
        }

        let todoItemsJsons = todoItems.compactMap {
            $0.value.json
        }

        do {
            let json = try JSONSerialization.data(
                withJSONObject: todoItemsJsons
            )
            try json.write(
                to: sourcePath,
                options: []
            )
        } catch {
            print(
                "saveTodoItems(to fileName: String?) - error writing to the file: \(error.localizedDescription)"
            )
            return
        }
    }
}
// MARK: Private Functions
private extension FileCache {
    func createSourcePath() {
        guard var documents = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            print(
                "getSourcePath(with fileName: String?) - error creating the source path"
            )
            return
        }
        documents.append(
            path: "CacheStorage"
        )

        do {
            try fileManager.createDirectory(
                at: documents,
                withIntermediateDirectories: true
            )
        } catch {
            print(
                """
                getSourcePath(with fileName: String?)
                - error creating the CacheStorage dir: \(error.localizedDescription)
                """
            )
        }

        path = documents
    }

    private func getSourcePath(
        with fileName: String = "default.json"
    ) -> URL? {
        if path == nil {
            createSourcePath()
        }
        guard var sourcePath = path else {
            return nil
        }

        sourcePath.append(
            path: fileName
        )

        return sourcePath
    }
}

// MARK: SwiftData
@MainActor
extension FileCache {
    func insert(_ todoItem: TodoItem) {
        let swiftDataItem = SwiftDataItem.toSwiftDataItem(todoItem)
        guard !todosSwiftData.contains(todoItem) else { return }
        modelContext?.insert(swiftDataItem)
        save()
        fetch()
    }

    func fetch() {
        guard let modelContext = modelContext else {
            self.error = OtherErrors.nilContext
            return
        }

        let todoDescriptor = FetchDescriptor<SwiftDataItem>(
            predicate: nil,
            sortBy: [
                .init(\.text)
            ]
        )

        do {
            swiftDataItems = try modelContext.fetch(todoDescriptor)
            todosSwiftData = swiftDataItems.map { SwiftDataItem.toTodoItem($0) }
            sortTasksByDeadline()
        } catch {
            self.error = error
        }
    }

    func delete(_ todoItem: TodoItem) {
        if let item = swiftDataItems.first(where: { $0.id == todoItem.id}) {
            modelContext?.delete(item)
        }
        save()
        fetch()
    }

    func update(_ todoItem: TodoItem) {
        let swiftDataItem = SwiftDataItem.toSwiftDataItem(todoItem)
        if let duplicate = swiftDataItems.first(where: { $0.id == todoItem.id}) {
            modelContext?.delete(duplicate)
        }

        modelContext?.insert(swiftDataItem)
        save()
        fetch()
    }

    private func save() {
        guard let modelContext = modelContext else {
            self.error = OtherErrors.nilContext
            return
        }
        do {
            try modelContext.save()
        } catch {
            print(error)
            self.error = error
        }
    }

    func sortTasksByDeadline() {
        todosSwiftData.sort(by: {
            guard let first = $0.deadline else { return false }
            guard let second = $1.deadline else { return true }
            return first < second
        })
    }
}
