//
//  ContentView.swift
//  SwiftUI-MVVM
//
//  Created by Yusuke Kita on 6/5/19.
//  Copyright © 2019 Yusuke Kita. All rights reserved.
//

import SwiftUI

struct RepositoryListView : View {
    // @ObjectBinding is appropriate, but it crashes somehow
    @EnvironmentObject var viewModel: RepositoryListViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.repositories) { repository in
                RepositoryListRow(repository: repository)
            }
            .navigationBarTitle(Text("Repositories"))
        }
        .onAppear(perform: { self.viewModel.onAppear() })
    }
}

#if DEBUG
struct RepositoryListView_Previews : PreviewProvider {
    static var previews: some View {
        RepositoryListView()
    }
}
#endif
