//
//  UpworkTestTests.swift
//  UpworkTestTests
//
//  Created by SELCUK YILDIZ on 13.01.23.
//

import XCTest

class ViewModelTests: XCTestCase {
    var viewModel: ViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ViewModel()
    }

    func testFetchRandomUsers() async throws {
       

       try await viewModel.fetchRandomUsers()
       

       
        XCTAssertGreaterThan(viewModel.users.count, 0)
    
    
    }

    func testDeleteUser() {
        let user = DummyModels.user
        viewModel.users = [user]

        viewModel.deleteUser(with: user.id)

        XCTAssertEqual(viewModel.users.count, 0)
    }

    func testToggleFav() {
        let user = DummyModels.user
        viewModel.users = [user]

        viewModel.toggleFav(for: user.id)

        XCTAssertEqual(viewModel.users[0].fav, true)
    }
}

