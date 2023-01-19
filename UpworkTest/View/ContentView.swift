//
//  ContentView.swift
//  UpworkTest
//
//  Created by SELCUK YILDIZ on 13.01.23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()
    
    
    /**
         Navigation Path
     Model driven navigation logic. Available from iOS 16
     */
    @State private var path : [User] = []
    
    
    @State var navVisibility : NavigationSplitViewVisibility = .doubleColumn
    
    
    
    
    var body: some View {
        NavigationSplitView(columnVisibility : $navVisibility) {
            NavigationStack(path: $path) {
                ScrollViewReader { proxy in
                    ZStack {
                      
                        List(viewModel.users, id: \.id) { user in
                           
                            UserRowView(user: user, path: $path)
                                    .id(user.id)
                                    .environmentObject(viewModel)
                            
                        }.navigationTitle("Users")
                            .searchable(text: $viewModel.text, suggestions: {
                                LazyVStack {
                                    ForEach(viewModel.filteredUsers, id: \.id) { user in
                                        
                                        UserRowView(user: user, path: $path)
                                            .id(user.id)
                                            .environmentObject(viewModel)
                                    }
                                }
                            })
                       
                        .navigationDestination(for: User.self) { user in
                           UserDetailView(user: user)
                                .environmentObject(viewModel)
                        }
                        VStack {
                            Spacer()
                            Button {
                                Task {
                                    do {
                                       try await viewModel.fetchRandomUsers()
                                    } catch {
                                        print(error)
                                    }
                                }
                            } label: {
                                Label("Fetch More", systemImage: "chevron.down")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .font(.caption)
                            }
                            .padding(4)
                            .background(.blue)
                            .clipShape(Capsule())
                            .shadow(radius: 16)

                        }
                    }
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarTrailing) {
                           Menu {
                               Picker(selection: $viewModel.sortOption, label: Text("Sort options")) {
                                    
                                   ForEach(SortOption.allCases, id: \.self) { option in
                                       Text(option.rawValue)
                                    }
                                    
                                }
                            } label: {
                                
                                Image(systemName: "slider.horizontal.3")
                            }
                        
                            
                            
                        }
                    })
                }
               
            }.task {
                do {
                   try await viewModel.fetchRandomUsers()
                } catch {
                    print(error)
                }
            }
        } detail: {
            List(viewModel.users.filter({$0.fav == true}), id: \.id) { user in
               
                UserRowView(user: user, path: $path)
                        .id(user.id)
                        .environmentObject(viewModel)
                
            }.navigationTitle("Favorites")
        }

      
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
