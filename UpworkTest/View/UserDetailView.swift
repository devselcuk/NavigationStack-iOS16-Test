//
//  UserDetailView.swift
//  UpworkTest
//
//  Created by SELCUK YILDIZ on 13.01.23.
//

import SwiftUI

struct UserDetailView: View {
    
    let user : User
    @EnvironmentObject var viewModel : ViewModel
    @State var path : [User] = []
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
          
                
              
               
                List {
                    Section("Info") {
                        VStack(alignment : .center) {
                            AsyncImage(url: URL(string: user.picture.large)) { phase in
                                switch phase {
                                case .empty :
                                    ProgressView()
                                case .failure(_) :
                                    Image(systemName: "person")
                                        .resizable()
                                case .success(let image) :
                                    image
                                        .resizable()
                                @unknown default:
                                    Image(systemName: "person")
                                        .resizable()
                                }
                            }
                            .frame(width: 120,height: 120)
                            .clipShape(Circle())
                            HStack(alignment : .top, spacing : 16) {
                                
                                VStack( spacing: 4) {
                                    
                                    Text(user.email)
                                        .font(.subheadline)
                                    Text(user.fullName)
                                        .font(.largeTitle)
                                    Text(user.phone)
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                }.padding(.top,16)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                  
                        Section("More") {
                            Text(user.gender)
                            Text(user.registrationDateString)
                            Text(user.fullAddress)
                        }
                       
                        
                
                    Section("Users Near \(user.fullName) (closer than 2500km)") {
                        ForEach(viewModel.users.filter({$0.isNear(of: user) && $0.id != user.id}), id: \.id) { user in
                           UserRowView(user: user, path: $path )
                        }
                    }
                }.navigationBarTitleDisplayMode(.inline)
                
             
            
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(user: DummyModels.user)
    }
}
