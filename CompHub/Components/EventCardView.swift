import SwiftUI


struct EventCardView : View {
    var event : EventTask
    var body : some View {
        HStack (alignment : .center, spacing : 15){
                AsyncImage(url : URL(string : event.images)
                ) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode : .fit)
                    }
                }
                .frame(width : 120 , height : 80)
                .cornerRadius(10)
                VStack (alignment : .leading) {
                    Text(event.title).multilineTextAlignment(.leading)
                    Text("24 - 26 November")
                        .font(.system(size : 14 , design: .default ))
                }
                .foregroundColor(.black)
            }
     
    }
}
