//
//  ViewModel.swift
//  UpworkTest
//
//  Created by SELCUK YILDIZ on 13.01.23.
//

import Foundation
import Combine
import SwiftUI


class ViewModel : ObservableObject {
    
    
    
    private var cancellables = Set<AnyCancellable>()
    @Published var users = [User]()
    @Published var text = ""
    @Published var filteredUsers = [User]()
    @Published var fetchedUsers = [User]()
    @Published var sortOption  : SortOption = .name
    
    
    init() {
        $text
            .debounce(for: 0.7, scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.filterUsers(with: text)
            }.store(in: &cancellables)
        $fetchedUsers
            .removeDuplicates()
            .sink { [weak self] users in
                self?.users = users
            }.store(in: &cancellables)
        $sortOption
            .sink { [weak self] option in
                switch option {
                case .gender :
                      self?.fetchedUsers.sort(by: { lhs, rhs in
                        lhs.gender < rhs.gender
                    })
                case .name:
                    self?.fetchedUsers.sort(by: { lhs, rhs in
                      lhs.fullName < rhs.fullName
                  })
                }
            }.store(in: &cancellables)
        
    }
    
    @MainActor
    func fetchRandomUsers() async throws {
        
        guard let url = URL(string: "https://api.randomuser.me/?results=40") else { throw CustomError.badFormattedURL}
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let newResults = try JSONDecoder().decode(Results.self, from: data)
        
        self.fetchedUsers.append(contentsOf: newResults.results)
        self.filteredUsers = fetchedUsers
        
        
        
    }
    
    
    
    
    func deleteUser(with id : String) {
        if let index = users.firstIndex(where: {$0.id == id}) {
            withAnimation {
                users.remove(at: index)
            }
        }
    }
    
    func toggleFav(for id : String) {
        
        if let index = users.firstIndex(where: {$0.id == id}) {
            
            withAnimation {
                if users[index].fav == true {
                    users[index].fav = false
                } else {
                    users[index].fav  = true
                }
            }
            
            
        }
    }
    
    
    
    func filterUsers(with text : String) {
        
        filteredUsers = text.isEmpty ? users : users.filter({$0.fullName.lowercased().contains(text.lowercased()) || $0.email.lowercased().contains(text.lowercased())})
    }
    
    
    
}
