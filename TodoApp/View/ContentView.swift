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
    @State private var animatingButton: Bool = false
    @State private var showingSettingsView: Bool = false
    
    @FetchRequest(
        entity: Todo.entity(),
        sortDescriptors: [NSSortDescriptor(
            keyPath: \Todo.name,
            ascending: true)])
    var todos: FetchedResults<Todo>
    
    var body: some View {
        NavigationView {
            ZStack {
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
                            self.showingSettingsView.toggle()
                        }){
                            Image(systemName: "paintbrush")
                                .imageScale(.large)
                        }
                        .sheet(isPresented: $showingSettingsView) {
                            SettingsView()
                        }
                )
                if todos.count == 0{
                    EmptyListView()
                }
            }
            .sheet(isPresented: $showingAddTodoView) {
                AddTodoView().environment(\.managedObjectContext, self.managedObjectContext)
            }
            .overlay(
                ZStack {
                    Group {
                        Circle()
                            .fill(.blue)
                            .opacity(self.animatingButton ? 0.2 : 0)
                            .scaleEffect(self.animatingButton ? 1 : 0)
                            .frame(width: 68, height: 68, alignment: .center)
                        
                        Circle()
                            .fill(.blue)
                            .opacity(self.animatingButton ? 0.15 : 0)
                            .scaleEffect(self.animatingButton ? 1 : 0)
                            .frame(width: 88, height: 88, alignment: .center)
                    }
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
                    
                    Button(action: {
                        self.showingAddTodoView.toggle()
                    }){
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                    }
                    .onAppear(perform: {
                        self.animatingButton.toggle()
                    })
                }
                    .padding(.bottom, 15)
                    .padding(.trailing, 15)
                , alignment: .bottomTrailing
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
