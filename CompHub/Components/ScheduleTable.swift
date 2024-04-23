import SwiftUI

struct ScheduleTable: View {
    var schedule : Match
    
    var body: some View {
        VStack (alignment : .leading) {
            Text(schedule.matchStart).font(.system(size : 15))
            HStack {
                AsyncImage(url : URL(string : schedule.fteam.image)
                    ) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode : .fit)
                        }
                    }
                    .frame(width : 30 , height :30)
                    Text(schedule.fteam.name)
                    
                    Spacer()
                    Text(String(schedule.fteam_score))
                }
                Divider()
                HStack {
                    AsyncImage(url : URL(string : schedule.steam.image)
                    ) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode : .fit)
                                
                        }
                    }
                    .frame(width : 30 , height :30)
                    Text(schedule.steam.name)
                    Spacer()
                    Text(String(schedule.steam_score))
                }
            }
        .foregroundColor(.black)
            .padding()
        
    }
}

//struct ScheduleTable_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleTable()
//    }
//}
