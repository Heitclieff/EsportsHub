//
//  ContentView.swift
//  dockits
//
//  Created by Kittituch pulprasert on 8/2/2567 BE.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var eventmodel : EventViewModel
    @State private var Searchtearms : String = ""
    
    @Binding var tabbarColor : UIColor
    
    var body: some View {
        VStack{
            HStack() {
                VStack (alignment : .leading) {
                    Text("Esports Hub")
                        .font(.system(size : 32 ,weight : .bold , design : .default))
                    
                    HStack (spacing : 5) {
                        Image(systemName: "globe.asia.australia")
                        Text("Explore")
                    }
                }
                .foregroundColor(.white)
                Spacer()
            }
            .padding(.leading)
            .padding(.bottom)
            CarouselView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
                  Color("Bg")
                      .ignoresSafeArea()
        }
        .onAppear {
            tabbarColor = .white
        }
    }

        
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ContentView()
//                .environmentObject(EventViewModel())
//        }
//
//    }
//}
