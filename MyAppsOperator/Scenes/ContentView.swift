//
//  ContentView.swift
//  MyAppsOperator
//
//  Created by Doyoung on 2023/04/17.
//

import SwiftUI

struct ContentView: View {
   
    var body: some View {
        TabView {
            AnnouncementListView()
                .tabItem {
                    Label("리스트", systemImage: "list.bullet.clipboard")
                }
            CreateAnnouncementView()
                .tabItem {
                    Label("추가", systemImage: "plus.circle")
                }
        }
        .tint(.red)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
