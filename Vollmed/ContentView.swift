//
//  ContentView.swift
//  Vollmed
//
//  Created by Giovanna Moeller on 12/09/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack{
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            NavigationStack{
                MyAppointmentView()
            }
            .tabItem {
                Label("Minhas Consultas", systemImage: "calendar")
            }
            
        }
    }
}

#Preview {
    ContentView()
}
