
import Foundation
import SwiftUI

struct EditMatchView : View {
    @EnvironmentObject var matchModel: MatchModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var match : Match
    var doc_id : String
    @State private var participants_list : [participantsResponse​​] = []
    @State private var matchFields =  MatchingEdit (
        firstTeamScore: "0" ,
        secondTeamScore: "0"
    )
    
    @State private var firstTeamScore =  "0"
    @State private var secondTeamScore = "0"
    
    @State private var ShowingAlert = false
    @State private var Alertdialog = ""
    @State private var isLoading = false
    
    var numberFormatter: NumberFormatter = {
          let nf = NumberFormatter()
          nf.locale = Locale.current
          nf.numberStyle = .decimal
          
          return nf
      }()
    
    var body : some View {
        VStack {
            List {
                Section("Select Team") {
                    HStack {
                        Text("\(match.fteam.teams_text)")
                        TextField("0" , text: $matchFields.firstTeamScore)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                }
                Section ("Against Team")  {
                    HStack {
                        Text("\(match.steam.teams_text)")
                        TextField("0" , text: $matchFields.secondTeamScore)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                }
                VStack {
                    Button() {
                        matchModel.makeMatchEnd(doc_id: doc_id, match_id: match.id)
                        self.match.isEnd = true
                        presentationMode.wrappedValue.dismiss()
                    }label : {
                        Text("Make is End")
                            .frame(maxWidth : .infinity)
                            .frame(height : 40)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                    .padding(.vertical, 12)
                    
                    .listRowBackground(EmptyView())
                    .listRowInsets(EdgeInsets())
                    Button(){
                        self.isLoading = true

                        let error = matchModel.EditMatch(doc_id: doc_id , match_id: match.id , information: matchFields)
                        self.ShowingAlert = error.isError
                        self.Alertdialog = error.task
                        
                        if(!error.isError) {
                            self.match.fteam_score = Int(matchFields.firstTeamScore) ?? 0
                            self.match.steam_score = Int(matchFields.secondTeamScore) ?? 0
                            presentationMode.wrappedValue.dismiss()
                        }
                        self.isLoading = false

                    }label : {
                        if(isLoading) {
                            ProgressView()
                                .frame(maxWidth : .infinity)
                                .frame(height : 28)
                        }else {

                            Text("Edit Match")
                                .frame(maxWidth : .infinity)
                                .frame(height : 28)
                        }
                    }
                    .padding(.vertical, 12)
                    .buttonStyle(.borderedProminent)
                    .listRowBackground(EmptyView())
                    .listRowInsets(EdgeInsets())
                }
               
            }
            
        }
        .navigationTitle("Edit Match")
        .onAppear() {
            self.matchFields.firstTeamScore = String(match.fteam_score)
            self.matchFields.secondTeamScore = String(match.steam_score)
        }
        .alert(isPresented: $ShowingAlert) {
                Alert(
                    title: Text(Alertdialog),
                    dismissButton: .default(Text("OK"), action: {
                        self.ShowingAlert = false
                    })
                )
        }
    }
}



//struct CreateMatchView_Previews : PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            CreateMatchView(id : "wg7EXyef09yAiFUn7CoH" , mode : "teams")
//                .environmentObject(MatchModel())
//        }
//    }
//}
