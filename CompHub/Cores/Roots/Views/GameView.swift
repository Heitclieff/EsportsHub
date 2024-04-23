//
//  GameView.swift
//  CompHub
//
//  Created by Kittituch pulprasert on 23/4/2567 BE.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var eventmodel : EventViewModel
    @State var results : [EventTask] = []
    var game : String
    
    var body: some View {
        ScrollView(.vertical , showsIndicators: false ) {
            VStack (alignment :.leading) {
                LazyVStack (spacing : 15) {
                    if(results.count > 0) {
                        ForEach(results , id : \.id) { item in
                            NavigationLink {
                                EventView(event: item)
                            } label : {
                                itemCardView(event: item)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .clipped()
        .navigationTitle("\(game)")

        .foregroundColor(.white)
        
        .onAppear() {
            eventmodel.fetchEventView(games : game) { result in
                self.results = result
            }
        }
        .accentColor(.pink)
    }
        
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GameView(game : "Valorant")
                .environmentObject(EventViewModel())
        }
    }
}
