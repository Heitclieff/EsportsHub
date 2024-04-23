import SwiftUI
import SlidingTabView

var isOpen = true

struct EventView: View {
    @State private var tabIndex = 0
    @State private var matchList: [Match] = []
    @State private var owner = ""
    @State private var GroupsIndex  = ""
    @State private var isRegistered = false
    @State private var Doc_count = 0
    @State private var isLoading = true
    @State var showParticipantsButton : [String] = []
    
    @State var isMyEvent = false
    var event : EventTask
    var date = transfromDate()
    
    func groupMatchByDate(date : String ) -> Bool {
        if self.GroupsIndex != date {
          self.GroupsIndex = date
          return true
        }
        return false
    }
    
    func setParticipantsButton(show : String) -> Bool {
        print("param" , show , self.showParticipantsButton)
        if(self.showParticipantsButton.count <= 0) {
            self.showParticipantsButton.append(show)
            return true
        }
        return false
    }
    
    var body: some View {
            GeometryReader { geometry in
                ScrollView {
                    VStack (alignment : .leading) {
                        AsyncImage(url : URL(string : event.images)
                        ) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode : .fill)
                                    
                            }
                        }
                        .background(Color.gray)
                        .frame(width : geometry.size.width ,height : 300)
                        VStack (alignment : .leading){
                            Text(event.title)
                                .font(.title)
                                .fontWeight(.bold)
                            Text(owner)
                                .font(.system(size : 15))
                                .foregroundColor(.gray)
                            Spacer()
                            if(!event.description.isEmpty) {
                                VStack  {
                                    Text(event.description)
                                        .font(.system(size : 15))
                                        .fixedSize(horizontal: false , vertical : true)
                                    
                                }
                                Spacer()
                            }
                            VStack (alignment :.leading){
                                Text("Competitive's type").fontWeight(.semibold);
                                Text(event.pattern)
                                Spacer()
                                Text("Teams").fontWeight(.semibold);
                                Text(String(event.participants))
                            }
                            .font(.system(size : 15))
                        }.padding()
                           

                        VStack (alignment : .leading) {
                            if(!event.isMatched)  {
                                VStack (alignment : .leading){
                                    NavigationLink() {
                                        ParticipantsView(id : event.id , mode : "teams").environmentObject(EventViewModel())
                                    }label : {
                                        Text("Participants")
                                        .frame(maxWidth : .infinity)
                                        .frame(height : 25)
                                    }
                                    .buttonStyle(.bordered)
                                   
                                    NavigationLink {
                                        TeamForms(isRegistered : $isRegistered, doc_id : event.id , participants: event.participants )
                                            .environmentObject(RegisterModel())
                                    }
                                    label: {
                                        Text(Int(Doc_count) != event.participants  ? isRegistered ? "Registered" : "Register Now" : "Register closed" )
                                            .frame(maxWidth : .infinity)
                                            .frame(height : 25)
                                        
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(.pink)
                                    .disabled(Int(Doc_count) != event.participants ? isRegistered : true)
                                    }.padding(5)
                                }
                            
                            SlidingTabView(selection : $tabIndex , tabs:["Schedule" , "Results"] , animation : .linear)
        
                                if(tabIndex == 0) {
                                    if(!event.isMatched) {
                                        if (matchList.count == 0) {
                                            VStack {
                                                Text("TBA")
                                                    .foregroundColor(.gray)
                                                    .frame(maxWidth: .infinity)
                                                    .italic()
                                                Text("Event will start in (\(event.startAt) - \(event.endAt))")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }else {
                                        HStack {
                                            NavigationLink() {
                                                ParticipantsView(id : event.id , mode : "teams").environmentObject(EventViewModel())
                                            }label : {
                                                Text("Participants")
                                                .frame(height : 25)
                                            }
                                            .buttonStyle(.borderedProminent)
                                            .cornerRadius(25)
                                            .tint(.pink)
                                            
                                            Spacer()
                                            if(isMyEvent) {
                                                NavigationLink {
                                                    CreateMatchView(matchList: $matchList, id: event.id)
                                                        .environmentObject(MatchModel())
                                                }
                                                label: {
                                                    Text("Create Match")
                                                        .frame(height :25)
                                                }
                                                .buttonStyle(.borderedProminent)
                                                .cornerRadius(25)
                                                .tint(.pink)
                                            }

                                        }.padding()
                                    
                                        
                                        ForEach(matchList) { match  in
                                            if(!match.isEnd) {
                                                let isGroups = groupMatchByDate(date : match.matchDate)
                                                if (isGroups) {
                                                    HStack {
                                                        Text(match.matchDate.uppercased())
                                                            .fontWeight(.semibold)
                                                        
                                                        Spacer()
                                                    }.padding(12)
                                                }
                                                NavigationLink {
                                                    DetailView(match: match, isMyEvent: isMyEvent, doc_id : event.id)
                                                        .environmentObject(EventViewModel())
                                                } label : {
                                                    ScheduleTable(schedule: match)
                                                }
                                            }
                                        } 
                                    }
                                  
                                
                                }else {
                                    if(matchList.count > 0) {
                                        ForEach(matchList) { match in
                                            if(match.isEnd){
                                                let isGroups = groupMatchByDate(date : match.matchDate)
                                         
                                                if (isGroups) {
                                                    HStack {
                                                        Text(match.matchDate.uppercased())
                                                            .fontWeight(.semibold)
                                                        
                                                        Spacer()
                                                    }.padding(12)
                                                }
                                                NavigationLink {
                                                    DetailView(match: match, isMyEvent: isMyEvent, doc_id :event.id)
                                                        .environmentObject(EventViewModel())
                                                } label : {
                                                    ScheduleTable(schedule: match)
                                                }
                                            }
                                        }
                                    }else {
                                        Text("TBA")
                                            .italic()
                                            .foregroundColor(.gray)
                                            .frame(maxWidth :.infinity)
                                    }
                                }  
                        }
                        .padding(.leading, 10)
                        .padding(.trailing,10)
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            .onAppear {
                EventViewModel().fetchEventSchedule(id: event.id) { reciveditem in
                    self.matchList = reciveditem
                }
                let id = UserDefaults.standard.string(forKey: "user_id") ?? ""
                EventViewModel().findingEventRegistered(id: id, doc_id: event.id) {res in
                    self.isRegistered = res.isRegisered
                    self.Doc_count = res.doc_count
                }
                EventViewModel().findingOwnEvent(id: event.id){ reciveditem in
                    self.owner = reciveditem.name
                    var myid = UserDefaults.standard.string(forKey: "user_id")
                    
                    self.isMyEvent = myid == reciveditem.id
                }
            }
        }
}

struct EventView_Previews: PreviewProvider {
    @EnvironmentObject var eventitem : EventViewModel
    static var previews: some View {
        NavigationView {
            EventView(event : EventGuide)
                .environmentObject(EventViewModel())
        }
    }
}




func transfromDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE, MMMM d"
    let dateString = dateFormatter.string(from: Date())
    
    return dateString
}
