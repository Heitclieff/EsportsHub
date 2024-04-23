//
//  DetailView.swift
//  dockits
//
//  Created by Kittituch pulprasert on 27/3/2567 BE.
//
import SwiftUI
import Foundation

struct DetailView: View {
    @State private var teamlist: [Teams] = []
    @State private var player: [Against] = []
    @State var match : Match
    var isMyEvent : Bool
    var doc_id : String

    let columns = [
            GridItem(),
            GridItem(),
            GridItem(),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment :.center) {
                HStack (spacing : 20){
                    VStack {
                        AsyncImage(url : URL(string : match.fteam.image)
                        ) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode : .fit)
                            }
                        }
                        .frame(width : 70 , height :70)
                        

                        Text(match.fteam.name)
                    }
                    Text("\(match.fteam_score) : \(match.steam_score)")
                    VStack {
                        AsyncImage(url : URL(string : match.steam.image)
                        ) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode : .fit)
                            }
                        }
                        .frame(width : 70 , height :70)
                        
                        Text(match.steam.name)
                    }
                }.frame(width : 300)
                Spacer(minLength: 40)
                VStack (alignment : .leading) {
                    Text("Current Roster")
                        .fontWeight(.semibold)
                    Spacer(minLength: 10)
                    
                    ForEach(player, id:\.id) { team in
                        VStack {
//                            HStack {
//                                AsyncImage(url : URL(string : team.image)
//                                ) { phase in
//                                    if let image = phase.image {
//                                        image
//                                            .resizable()
//                                            .aspectRatio(contentMode : .fit)
//                                    }
//                                }
//                                .frame(width : 20 , height : 20)
//                                Text(team.name)
//                            }
                            
                            LazyVGrid(columns: columns , spacing : 20) {
                                ForEach(team.players) {playerlist in
                                    VStack {
                                        AsyncImage(url : URL(string : playerlist.image)
                                        ) { phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode : .fit)
                                            }
                                        }
                                        .frame(width : 40 , height : 40)

                                        Text(playerlist.name)

                                        if(playerlist.isReserved) {
                                            Text("(reserve)").font(.system(size : 12))
                                        }

                                    }

                                }
                                
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(6)
                            .shadow(radius: 3)
                            
                            Spacer(minLength: 30)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isMyEvent {
                        if(!match.isEnd){
                            NavigationLink(destination: EditMatchView(match : $match , doc_id : doc_id).environmentObject(MatchModel())) {
                                Text("Edit Match")
                            }
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                self.player = []
                EventViewModel().fetchAgainstTeam(team_id: match.fteam.id) { reciveditem in
                    EventViewModel().fetchAgainstTeam(team_id: match.steam.id) {recivedPlayers in
                        if(self.player.isEmpty) {
                            self.player.append(reciveditem)
                            self.player.append(recivedPlayers)
                        }
                    }
                }
            }
        }
    }
}


//
//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(match : )
//    }
//}

