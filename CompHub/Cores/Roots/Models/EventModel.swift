//
//  EventModel.swift
//  CompHub
//
//  Created by Kittituch pulprasert on 28/3/2567 BE.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseDatabaseSwift

struct EventTask : Identifiable {
    var id : String
    var title : String
    var images : String
    var description : String
    var games : String
    var type : String
    var pattern : String
    var areavisiblity : Int
    var participants : Int
    var startAt : String
    var endAt : String
    var isMatched : Bool
}

struct Teams : Identifiable  {
    var id: String
    var name: String
    var image: String
    var teams_text: String

}

struct Match : Identifiable {
    var id : String
    var fteam : Teams
    var steam : Teams
    var fteam_score : Int
    var steam_score : Int
    var matchDate : String
    var matchStart : String
    var isEnd : Bool
}

struct Player : Identifiable {
    var id : String
    var name : String
    var image : String
    var national : String
    var teams : String
    var isReserved : Bool
}

struct Against  {
    var id : String
    var players : [Player]
}

struct OwnEvent  {
    var id : String
    var name : String
}
struct EventConfig  {
    var isRegisered : Bool
    var doc_count : Int
}

struct RegisterResponse {
    var isRegister : Bool
}

struct participantsResponse​​{
    var id : String
    var name : String
    var isyou : Bool
}
let EventGuide = EventTask (
    id : "1",
    title : "Valorant",
    images : "https://cdn.oneesports.gg/cdn-data/2024/03/Valorant_MastersMadrid_KeyVisual-1024x576.jpg",
    description : "",
    games : "valorant",
    type : "A",
    pattern : "B",
    areavisiblity : 10,
    participants : 10,
    startAt : "24 Wed",
    endAt : "26 Fri",
    isMatched: false
)

class EventViewModel: ObservableObject {
    @Published
    var eventlist : [EventTask] = []
    var matchlist : [Match] = []
    var errortask : [String] = []
    
    var db = Firestore.firestore()
    private var Rtref = Database.database().reference()
    
    func fetchEventView(games: String , completion : @escaping ([EventTask]) -> Void) {
        self.eventlist = []
        let docRef = db.collection("events").whereField("games", isEqualTo: games.lowercased())
        docRef.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let doc_id = document.documentID as String
                    
                    let startAt_timestamp = data["startAt"] as! Timestamp
                    let endAt_timestamp = data["endAt"] as! Timestamp
                    
                    
                    let startAt =  self.transfromDate(date: startAt_timestamp.dateValue())
                    let endAt = self.transfromDate(date: endAt_timestamp.dateValue())
                           
                    let item = EventTask(
                        id: doc_id,
                        title: data["title"] as? String ?? "",
                        images: data["images"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        games: data["games"] as? String ?? "",
                        type: data["type"] as? String ?? "",
                        pattern: data["pattern"] as? String ?? "",
                        areavisiblity: data["areavisiblity"] as? Int ?? 0,
                        participants: data["participants"] as? Int ?? 0,
                        startAt: startAt,
                        endAt: endAt,
                        isMatched: data["isMatched"] as? Bool ?? false
                    )
                    self.eventlist.append(item)
                }
                completion(self.eventlist)
            }
        }
    }
    
    func findingEventRegistered (id: String , doc_id : String , completion: @escaping (EventConfig) -> Void) {
        let eventRef = db.collection("events").document(doc_id)
        let participantRef = eventRef.collection("participants")

        participantRef.getDocuments { snapshot, error in
               guard error == nil else {
                   print("Error fetching documents: \(error!.localizedDescription)")
                   completion(EventConfig(isRegisered: false , doc_count: 0))
                   return
               }

               if let snapshot = snapshot {
                   let count = snapshot.documents.count
                   print("Number of documents: \(count)")
                   
                   let isRegistered = snapshot.documents.contains { document in
                       let data = document.data()
                       if let register_id = data["register_id"] as? String {
                           return register_id == id
                       }
                       return false
                   }

                   completion(EventConfig(isRegisered: isRegistered, doc_count: count))
               } else {
                   print("Snapshot is nil")
               }
           }

    }
    
    func fetchAgainstTeam (team_id : String , completion: @escaping (Against) -> Void) {
        let teamRef = db.collection("teams")

        let Team_ref = teamRef.document(team_id).collection("roaster")
        var player_list : [Player] = [];

        Team_ref.getDocuments { snapshot ,error in
            guard let documents = snapshot?.documents else { return }
                for players in documents  {
                    let data = players.data()
                    let id = players.documentID as String
                
                    let players_obj = Player(
                        id: id ,
                        name : data["name"] as! String,
                        image : data["image"] as! String,
                        national: data["national"] as! String ,
                        teams :  data["teams"] as! String,
                        isReserved: data["isReserved"] as! Bool
                    )
                
                    player_list.append(players_obj)
                }
                completion(Against(id: team_id , players: player_list))
            }
        
    }
    
    func fetchEventSchedule(id: String, completion: @escaping ([Match]) -> Void) {
        let docRef = db.collection("events").document(id);
        let matchRef = docRef.collection("match");
        
        matchRef.getDocuments { snapshot ,error in
            guard let documents = snapshot?.documents else { return }
            
            	
            for subs in documents {
                let data = subs.data()
                let doc_id = subs.documentID as String
                
                let fteam = data["fteam"] as! DocumentReference
                let steam = data["steam"] as! DocumentReference
                
                var matchDate =  ""
                var matchStart = ""
                
                if let timestamp = data["startAt"] as? Timestamp {
                     let date = timestamp.dateValue()
                     
                     let dateFormatter = DateFormatter()
                     dateFormatter.dateFormat = "EEE, MMMM d"

                     let timeFormatter = DateFormatter()
                     timeFormatter.dateFormat = "h:mm a"
                    
                     matchDate = dateFormatter.string(from: date)
                     matchStart = timeFormatter.string(from: date)
                }

                	
                var teamA : Teams?
                var teamB : Teams?
                
                fteam.getDocument {query , err  in
                    guard let itemA = query?.data() else { return }
                    let teamA_id = fteam.documentID as String
                    let insertItemA = Teams(
                        id: teamA_id ,
                        name : itemA["name"] as! String ,
                        image : itemA["image"] as! String,
                        teams_text : itemA["teams_text"] as! String
                    )
                    
                    teamA = insertItemA
                }
                
                steam.getDocument {query , err  in
                    guard let itemB = query?.data() else { return }
                    let teamB_id = steam.documentID as String
                    
                    let insertItemB = Teams(
                        id: teamB_id ,
                        name : itemB["name"] as! String ,
                        image : itemB["image"] as! String,
                        teams_text : itemB["teams_text"] as! String
                    )
                    
                    teamB = insertItemB
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if let fteam = teamA, let steam = teamB {
                        let matchItem = Match(
                            id: doc_id,
                            fteam: fteam,
                            steam: steam,
                            fteam_score: data["fteam_score"] as! Int,
                            steam_score: data["steam_score"] as! Int,
                            matchDate: matchDate  ,
                            matchStart: matchStart,
                            isEnd : data["isEnd"] as? Bool ?? false
                        )
                        self.matchlist.append(matchItem)
                        completion(self.matchlist)
                    }
                }
            }
        }
    }
}

extension EventViewModel {
    func fetchParticipants(id : String , mode : String, completion : @escaping ([participantsResponse​​]) -> Void)  {
        let docRef = db.collection("events").document(id)
        let participantsRef = docRef.collection("participants");
        let myid = UserDefaults.standard.string(forKey: "user_id");
        
        participantsRef.getDocuments { snapshot ,error in
            guard let documents = snapshot?.documents else { return }
            var participants_list : [participantsResponse​​] = []
            for documentsRef in documents {
                let data = documentsRef.data()
                if(mode == "players") {
                    let id = documentsRef.documentID as String
                    let name = data["name"] as! String
                    let register_id = data["register_id"] as? String ?? ""
                    let isyou = register_id == myid
                    
                    participants_list.append(
                        participantsResponse​​(id: id ,name: name , isyou: isyou)
                    )
                    
                }else {
                    let dockeys = data["id"] as! DocumentReference
                    dockeys.getDocument { query,  err in
                        guard let partiref = query?.data() else { return }
                       
                        let name = partiref["name"] as? String ?? ""
                        let dockey_id = dockeys.documentID as String
                        let register_id = partiref["register_id"] as? String ?? ""
                        let isyou = register_id == myid

                        participants_list.append(
                            participantsResponse​​(id : dockey_id , name : name , isyou: isyou)
                        )
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion(participants_list)
            }
        }
    }
    
    func findingOwnEvent (id : String , completion :@escaping (OwnEvent) -> Void) {
        let docRef = db.collection("events").document(id)
        
        docRef.getDocument {query ,error in
            guard let data  = query?.data() else { return }
            
            let createBy = data["createBy"] as! DocumentReference
            
            createBy.getDocument {qry , error in
                guard let subs  = qry?.data() else { return }
                
                let id = createBy.documentID as String
                let name = subs["name"] as? String ?? ""
                
                completion(OwnEvent(id: id , name: name))
            }
        }
    }
}

extension EventViewModel {
    func transfromDate(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
}
