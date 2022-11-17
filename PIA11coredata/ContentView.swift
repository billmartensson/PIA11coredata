//
//  ContentView.swift
//  PIA11coredata
//
//  Created by Bill Martensson on 2022-11-17.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    /*
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Todo.thingtodo, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Todo>
     */
    
    @State var todoitems = [Todo]()
    
    
    @State var addTodoText = ""
    
    
    var body: some View {
        NavigationView {
            
            VStack {
                TextField("", text: $addTodoText)
                
                List {
                    ForEach(todoitems) { todoitem in
                        
                        
                        NavigationLink(destination: TodoDetailView(currenttodo: todoitem)) {

                            VStack {
                                Text(todoitem.thingtodo!)
                                
                                if(todoitem.done == true) {
                                    Text("KLAR")
                                } else {
                                    Text("EJ KLAR")
                                }
                            }

                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            }.onAppear() {
                loaddata()
            }
            
        }
    }

    func loaddata() {
        
        let fetch = Todo.fetchRequest()
        
        let sorting = NSSortDescriptor(key: "done", ascending: true)
        
        fetch.sortDescriptors = [sorting]
        
        //fetch.predicate = NSPredicate(format: "done == %@", false)
        
        do {
            let result = try viewContext.fetch(fetch)
            
            todoitems = result
            
        } catch {
            // Kunde inte ladda
        }
    }
    
    private func addItem() {
        withAnimation {
            let newTodo = Todo(context: viewContext)
            newTodo.thingtodo = addTodoText
            
            do {
                try viewContext.save()
                loaddata()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { todoitems[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
