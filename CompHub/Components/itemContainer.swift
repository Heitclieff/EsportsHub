import SwiftUI



struct itemCardView : View {
    var event : EventTask
    
    var body : some View {
            VStack (alignment : .leading) {
                GeometryReader { geometry in
                    ZStack (alignment : .bottomLeading) {
                        AsyncImage(url : URL(string : event.images)
                        ) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode : .fit)
                            }
                        }
                        .frame(width : geometry.size.width , height : geometry.size.height)
                        
                        VStack (alignment : .leading) {
                            Text(event.title)
                                .font(.system(size : 16 , weight : .semibold))
                                .frame(maxWidth: geometry.size.width , alignment : .leading)
                                
                            Text("\(event.startAt) - \(event.endAt)")
                                .font(.system(size : 14))
                                .frame(maxWidth: geometry.size.width , alignment : .leading)
                        }
                        .frame(width: geometry.size.width , alignment: .leading)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.5))
                        
                            
                    }

                    
                }
            }
                 
            .frame(maxWidth: .infinity , minHeight : 200)
            .cornerRadius(20)
            

        
     
    }
}
