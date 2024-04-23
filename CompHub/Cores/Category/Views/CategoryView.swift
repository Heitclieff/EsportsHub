import SwiftUI

struct CategoryView: View {
    var body: some View {
            VStack {
                ScrollView(.vertical , showsIndicators: false ) {
                    Spacer(minLength: 25)
                    VStack (spacing : 45) {
                        HStack() {
                            VStack (alignment : .leading) {
                                Text("Category")
                                    .font(.system(size : 32 ,weight : .bold , design : .default))
                                HStack  {
                                    Text("Choose event from you like")
                                        .font(.system(size : 16 ))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Spacer()
                            Circle()
                                .fill(Color(.white))
                                .frame(width : 30 , height : 30)
                        }
                    
                        LazyVStack (alignment :.leading , spacing : 15) {
                            HStack (spacing : 10){
                                Text("Games")
                                    .font(.system(size : 18, weight: .semibold))
                                Spacer();
                                Button(action : { }) {
                                    Text("View more")
                                        .font(.system(size : 16))
                                }
                            }
                          
                         
                            CateCardView()
                                
                            HStack (spacing : 10){
                                Text("Board Game")
                                    .font(.system(size : 18, weight: .semibold))
                                Spacer();
                                Button(action : { }) {
                                    Text("View more")
                                        .font(.system(size : 16))
                                }
                            }
                          
                         
                            CateCardView()
                            
                            HStack (spacing : 10){
                                Text("Card Battle")
                                    .font(.system(size : 18, weight: .semibold))
                                Spacer();
                                Button(action : { }) {
                                    Text("View more")
                                        .font(.system(size : 16))
                                }
                            }
                          
                         
                            CateCardView()
                        }
                    }
                    
                
                }
            }
            .padding()
            .clipped()
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}
