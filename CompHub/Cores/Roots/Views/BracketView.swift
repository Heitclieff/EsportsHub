
import SwiftUI

struct BracketView : View {
    var body : some View  {
        VStack {
            Text("This is Bracket View")
            Bracket()
        }.padding()
    }
}


struct Bracket_Previews : PreviewProvider {
    static var previews: some View {
        BracketView()
    }
}


struct Bracket : View {
    var body : some View {
        VStack (alignment : .leading) {
            HStack {
                Text("Sentinels")
                Spacer()
                Text("0")
            }
            .padding(10)
          
            Divider()
            HStack {
                Text("Paper Rex")
                Spacer()
                Text("2")
            }
            .padding(10)

        }
        .border(.black ,width : 0.2)
        .frame(width : 250)
    }
}
