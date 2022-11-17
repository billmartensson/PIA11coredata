//
//  TodoDetailView.swift
//  PIA11coredata
//
//  Created by Bill Martensson on 2022-11-17.
//

import SwiftUI
import CoreData

struct TodoDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var currenttodo : Todo
    
    @State var todotitle = ""
    @State var tododone = false
    
    @State var addsub = ""
    
    @State var allsubs = [Subtodo]()
    
    var body: some View {
        VStack {
            Text(currenttodo.thingtodo!)
            
            TextField("", text: $todotitle)
            
            Toggle(isOn: $tododone) {
                Text("Klar")
            }
            
            Button(action: {
                savetodo()
            }) {
                Text("Spara")
            }
            
            HStack {
                TextField("", text: $addsub)
                
                Button(action: {
                    savesub()
                }) {
                    Text("Lägg till")
                }
            }
            
            
            List {
                ForEach(allsubs) { sub in
                    Text(sub.todotitle!)
                }
                
            }
            
            
        }.onAppear() {
            todotitle = currenttodo.thingtodo!
            tododone = currenttodo.done
            
            loadsub()
        }
    }
    
    func loadsub() {
        if let todosubset = currenttodo.subrelationship {
            
            let subs = todosubset as! Set<Subtodo>
            
            let subarray = Array(subs)
            
            allsubs = subarray
            
        }
    }
    
    
    func savesub() {
        let newsub = Subtodo(context: viewContext)
        newsub.todotitle = addsub
        
        currenttodo.addToSubrelationship(newsub)
        
        do {
            try viewContext.save()
            loadsub()
        } catch {
            // Kunde inte spara
        }
    }
    
    
    func savetodo() {
        currenttodo.thingtodo = todotitle
        currenttodo.done = tododone
        
        do {
            try viewContext.save()
        } catch {
            // Kunde inte spara
        }
    }
    
}

struct TodoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetailView(currenttodo: Todo())
    }
}
