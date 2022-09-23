//
//  ContentView.swift
//  TodoApp
//
//  Created by Usha Sai Chintha on 23/09/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @State private var showingAddTodoView: Bool = false
    
    // @FetchRequest(
    //     sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)],
    //     animation: .default)
    // private var todos: FetchedResults<Todo>
    
    // we are saving the todo items by name and storing them in ascending order in database and retrieving it and storing it to todos variable
    @FetchRequest(
        entity: Todo.entity(),
        sortDescriptors: [NSSortDescriptor(
            keyPath: \Todo.name,
            ascending: true)])
    var todos: FetchedResults<Todo>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.todos, id: \.self) {todo in
                    HStack {
                        Text(todo.name ?? "Unknown")
                        Spacer()
                        Text(todo.priority ?? "Unknown")
                    }
                }
                .onDelete(perform: deleteTodo)
            }
            .navigationBarTitle("Todo", displayMode: .inline)
            .navigationBarItems(
                leading: EditButton(),
                trailing:
                    Button(action: {
                        self.showingAddTodoView.toggle()
                    }){
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $showingAddTodoView) {
                        AddTodoView().environment(\.managedObjectContext, self.managedObjectContext)
                    }
            )
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Todo(context: managedObjectContext)
            newItem.id = UUID()
            
            do {
                try managedObjectContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
