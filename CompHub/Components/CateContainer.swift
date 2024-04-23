import SwiftUI

struct Categroup  : Identifiable {
    let id : Int
    let title : String
    let image : String
}


struct CateCardView : View {
    @State private var groups: [Categroup] = [
        Categroup(id: 1, title: "Valorant" , image : "https://c.wallhere.com/photos/90/fd/Makima_Chainsaw_Man_closeup_tie_eyes_red_background-2269634.jpg!d"),
        Categroup(id: 2, title: "League of Legends" , image : "https://e1.pngegg.com/pngimages/991/840/png-clipart-league-of-legends-free-icon-lol-icon-blue-1-thumbnail.png"),
        Categroup(id: 3, title: "Arena of Valor" , image : "https://play-lh.googleusercontent.com/UD3M7vEIbLINyar4sV70Sf8k8jxzYVQKvwKDCeHF5IeVgVfLjB1aivaSV0WdJGyZetw=w240-h480-rw")
    ]
    
    var body : some View {
      
            VStack (alignment : .leading) {
                GeometryReader { geometry in
                    LazyVStack (alignment : .leading) {
                        ForEach(groups) { group in
                        HStack {
                            AsyncImage(url : URL(string : group.image),scale: 5)
                                .frame(width: 40 , height:40)
                                .cornerRadius(10)
                                .clipped()
                            Text(group.title)
                        }
                        
                    
                        }
                    }
                    .padding(30)
                
            }
                 
            .frame(maxWidth: .infinity , minHeight : 200)
            .background(Color.white)
            .cornerRadius(20 )
            .padding(8)
            .shadow(radius: 5)

        }
     
    }
}
