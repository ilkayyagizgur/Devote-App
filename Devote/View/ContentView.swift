//
//  ContentView.swift
//  Devote
//
//  Created by Ada Yagiz Gur on 19.02.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - PROPERTY
    
    @State var task: String = ""
    @State private var showNewTaskItem: Bool = false
    
    // FETCHING DATA
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    // MARK: - FUNCTION
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }//: DELETE FUNCTION
    
    // MARK: - BODY
    
    var body: some View {
        NavigationView {
            ZStack {
                // MARK: - MAIN VIEW
                
                VStack {
                    // MARK: - HEADER
                    Spacer(minLength: 80)
                    // MARK: - NEW TASK BUTTON
                    
                    Button(action: {
                        showNewTaskItem = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                    })
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .leading, endPoint: .trailing)
                            .clipShape(Capsule())
                            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)
                    )
                    
                    // MARK: - TASKS
                    
                    if #available(iOS 16.0, *) {
                        List {
                            ForEach(items) { item in
                                NavigationLink {
                                    Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                } label: {
                                    VStack(alignment: .leading) {
                                        Text(item.task ?? "")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                        
                                        Text(item.timestamp!, formatter: itemFormatter)
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }//: LIST ITEM
                                }
                               // .listRowBackground(Color.pink)
                            }
                            .onDelete(perform: deleteItems)
                        }//: LIST
                        .listStyle(InsetGroupedListStyle())
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                        .padding(.vertical, 0)
                        .frame(maxWidth: 640)
                        .scrollContentBackground(.hidden)
                    } else {
                        // Fallback on earlier versions
                    }
                }//: VSTACK
                
                // MARK: - NEW TASK ITEM
                
                if showNewTaskItem {
                    BlankView()
                        .onTapGesture {
                            withAnimation() {
                                showNewTaskItem = false
                            }
                        }
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
                
            }//: ZSTACK
            .onAppear() {
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .navigationBarTitle("Daily Tasks", displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .tint(.black)
                }
        }//: TOOLBAR
            .background(
                BackgroundImageView()
            )
            .background(
                backgroundGradient.ignoresSafeArea(.all)
            )
        }//: NAVIGATION
        .navigationViewStyle(StackNavigationViewStyle())
        
    }

    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
