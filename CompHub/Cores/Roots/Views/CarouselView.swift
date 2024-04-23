//
//  CarouselView.swift
//  CompHub
//
//  Created by Kittituch pulprasert on 23/4/2567 BE.
//

import SwiftUI

struct CarouselView: View {
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    private let games : [String] = ["https://cdn1.epicgames.com/offer/cbd5b3d310a54b12bf3fe8c41994174f/EGS_VALORANT_RiotGames_S2_1200x1600-d487933ba0a304bb1a5aa32d7c255bd0" , "https://nerdbot.com/wp-content/uploads/2022/01/league-of-legends-2022-official-art.jpg" ,
    "https://www.blognone.com/sites/default/files/externals/7a8f7fdb48d6d78b343d642cc2d6f736.jpg" ,
    "https://static.wikia.nocookie.net/cswikia/images/3/37/Cs2_boxart.jpg/revision/latest?cb=20230930151452" ,
    "https://e.snmc.io/lk/l/x/40325cce5c999001335145e975985cdd/9651551"]
    
    private let gameName : [String] = ["Valorant" , "League of legends" , "Dota2" , "Counter Strike 2" , "Rainbow six siege"]
    var body: some View {
            VStack {
                HStack {
                    Button () {
                        withAnimation {
                            currentIndex = max(0 , currentIndex - 1)
                        }
                    } label: {
                        Image(systemName : "arrow.left")
                            .frame(width : 12 , height :22)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.pink)
                    .cornerRadius(100)
                    Spacer()
                    Text("\(gameName[currentIndex])")
                        .fontWeight(.bold)
                        .font(.system(size : 20))
                        .foregroundColor(.white)
                    Spacer()
                    Button () {
                        withAnimation {
                            currentIndex = min(games.count - 1  , currentIndex + 1)
                        }
                    } label: {
                        Image(systemName : "arrow.right")
                            .frame(width : 15 , height :25)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.pink)
                    .cornerRadius(100)
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.bottom , 40)
                ZStack {
                    ForEach(0..<games.count ,id: \.self) { index in
                        AsyncImage(url : URL(string : games[index])) { image in
                                image.resizable()
                                    .aspectRatio(contentMode : .fill)
                                    .clipped()
                         
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 300 , height : 400)
                        .cornerRadius(25)
                        .opacity(currentIndex == index ? 1.0 : 0.5)
                        .scaleEffect(currentIndex == index ? 1.2 : 0.8)
                        .offset(x: CGFloat(index - currentIndex) * 300 + dragOffset, y:0)

                        
                    }
                }
                .gesture(
                    DragGesture()
                        .onEnded({value in
                            let threshold : CGFloat = 50
                            if value.translation.width > threshold {
                                withAnimation {
                                    currentIndex = max(0, currentIndex - 1)
                                }
                            } else if value.translation.width < -threshold {
                                withAnimation {
                                    currentIndex = min(games.count - 1 , currentIndex + 1)
                                }
                            }
                        })
                )
                NavigationLink {
                    GameView(game: gameName[currentIndex])
                }label : {
                    
                    Text("Enter to \(gameName[currentIndex])")
                    
                        .padding(5)
                }
                .buttonStyle(.borderedProminent)
                .tint(.pink )
                .cornerRadius(50)
                .padding(.leading)
                .padding(.trailing)
                .padding(.top, 45)
            }
        }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
    }
}
