//
//  UserRowView.swift
//  UpworkTest
//
//  Created by SELCUK YILDIZ on 13.01.23.
//

import SwiftUI

struct UserRowView: View {
    let user : User
    
    @EnvironmentObject var viewModel : ViewModel
    @Binding var path : [User]
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.picture.thumbnail)) { phase in
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
            .frame(width: 50,height: 50)
            .clipShape(Circle())
            .onTapGesture {
                path = [user]
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.fullName)
                    .font(.headline)
                Text(user.email)
                    .font(.subheadline)
                Text(user.phone)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(spacing : 8) {
                
                Text("Delete")
                    .padding(8)
                    .background(.red)
                    .clipShape(Capsule())
                    .foregroundColor(.white)
                    .font(.caption)
                    .onTapGesture {
                        viewModel.deleteUser(with: user.id)
                    }
                
                if let index = viewModel.users.firstIndex(of: user) {
                    if viewModel.users[index].fav == true {
                        Image(systemName: "heart.fill")
                            .onTapGesture {
                                viewModel.toggleFav(for: user.id)
                            }
                            .font(.system(size: 24))
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "heart")
                            .font(.system(size: 24))
                            .onTapGesture {
                                viewModel.toggleFav(for: user.id)
                            }
                            .foregroundColor(.red)
                        
                    }
                    
                }
                
                
                
                
                
            }
            
            
            
            
        }.padding(.horizontal)
    }
}






struct UserRowView_Previews: PreviewProvider {
    static var previews: some View {
        UserRowView(user: DummyModels.user, path: .constant([]))
            .environmentObject(ViewModel())
    }
}
