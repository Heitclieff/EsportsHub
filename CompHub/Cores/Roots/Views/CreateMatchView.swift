
import Foundation
import SwiftUI

struct CreateMatchView : View {
    @Binding var matchList : [Match]
    var id : String
    
    @EnvironmentObject var matchModel: MatchModel
    @Environment(\.presentationMode) var presentationMode

    @State private var participants_list : [participantsResponse​​] = []
    @State private var matchFields = MatchingAgainst(
        firstTeam:  "",
        secondTeam: "",
        firstTeamScore: "0" ,
        secondTeamScore: "0",
        startAt : Date.now  ,
        endAt : Date.now
    )
    
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
                    Picker("Team", selection :$matchFields.firstTeam) {
                        ForEach(participants_list ,id: \.id) { participants in
                                Text(participants.name).id(participants.id)
                        }
                    }
                    HStack {
                        Text("Score")
                        TextField("0", value: $matchFields.firstTeamScore , formatter: numberFormatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .foregroundColor(.gray)
                    }
                }
                Section ("Against Team")  {
                    Picker("Against Team", selection :$matchFields.secondTeam) {
                        ForEach(participants_list ,id: \.id) { participants in
                            if(matchFields.firstTeam != participants.id) {
                                Text(participants.name).id(participants.id)
                            }
                        }
                    }
                    HStack {
                        Text("Score")
                        TextField("0", value: $matchFields.firstTeamScore , formatter: numberFormatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                        
                    }
                }
                Section ("Match Date"){
                    DatePicker("Start",
                               selection: $matchFields.startAt,
                               in: Date()...,
                               displayedComponents: [.date, .hourAndMinute]
                               
                    )
                    .datePickerStyle(.compact)
                    .environment(\.locale, .init(identifier: "en"))
                    
                    DatePicker("End",
                               selection: $matchFields.endAt,
                               in: Date()...,
                               displayedComponents: [.date, .hourAndMinute]
                               
                    )
                    .datePickerStyle(.compact)
                    .environment(\.locale, .init(identifier: "en"))
                }
                Button(){
                    self.isLoading = true
                    let error =  matchModel.ValidationMatch(form: matchFields)

                    self.ShowingAlert =  error.isError
                    self.Alertdialog = error.task
                    
                    if(!error.isError) {
                        let res =  matchModel.createMatch(form: matchFields, id: id)

                        if(!res.response.isError) {
                            matchModel.BindingMatch(form: matchFields, id:id ,match_id: res.match_id) { reciveditem in
                                self.matchList.append(reciveditem)
                                self.isLoading = false
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }else {
                        self.isLoading = false
                    }
                    
                    
                }label : {
                    if(isLoading) {
                        ProgressView()
                            .frame(maxWidth : .infinity)
                            .frame(height : 28)
                    }else {
                        
                        Text("Create Match")
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
        .navigationTitle("Create Match")
        .onAppear() {
            EventViewModel().fetchParticipants(id: id,  mode : "teams") { recivedItem in
                if(recivedItem.count > 1) {
                    self.matchFields.firstTeam = recivedItem[0].id
                    self.matchFields.secondTeam = recivedItem[1].id
                }
                self.participants_list = recivedItem
            }
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
