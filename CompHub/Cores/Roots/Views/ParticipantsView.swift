import Foundation
import SwiftUI

struct ParticipantsView: View {
    var id : String
    var mode  : String
    @State private var participants_list : [participantsResponse​​] = []
    @State private var isLoading = true
    
    var body : some View  {
        VStack() {
            Text("Valorant Champions tour 2024").padding()
            List() {
                if(isLoading) {
                    ProgressView()
                }else {
                    ForEach(participants_list, id: \.id) { participants in
                        HStack {
                            Text(participants.name)
                            Spacer()
                            Text(participants.isyou ? "you" : "")
                                .foregroundColor(.gray)
                                .italic()
                        }
                    }
                }
            }
            
        }
        .navigationTitle("Participants")
        .onAppear() {
            EventViewModel().fetchParticipants(id: id,  mode : mode) { participants in
                self.participants_list = participants
                self.isLoading = false
            }

        }
    }
}

struct ParticipantsView_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView  {
            ParticipantsView(id : "wg7EXyef09yAiFUn7CoH", mode : "teams")
                .environmentObject(EventViewModel())
        }
    }
}
