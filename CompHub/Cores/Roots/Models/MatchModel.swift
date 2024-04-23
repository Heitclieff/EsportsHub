//
//  MatchModel.swift
//  CompHub
//
//  Created by Kittituch pulprasert on 21/4/2567 BE.
//

import Foundation
import Firebase

struct MatchingAgainst {
    var firstTeam : String
    var secondTeam : String
    var firstTeamScore : String
    var secondTeamScore : String
    var startAt : Date
    var endAt : Date
}

struct MatchingEdit {
    var firstTeamScore : String
    var secondTeamScore : String
}

struct MatchingResponse {
    var isError : Bool
    var task : String
}

struct CreateResponse {
    var match_id : String
    var response : MatchingResponse
}

class MatchModel : ObservableObject {
    @Published
    var error = MatchingResponse(isError: false, task: "" )
    var db  = Firestore.firestore()
    
    func ValidationMatch (form : MatchingAgainst) -> MatchingResponse{
        print(form)
        
        if(form.firstTeam.isEmpty || form.secondTeam.isEmpty) {
            return MatchingResponse(isError: true, task: "Please Enter Information.")
        }
        
        if(form.firstTeam == form.secondTeam) {
            return MatchingResponse(isError: true , task: "Please Select different team or player against.")
        }
        
        if(!self.CheckIntScore(number: form.secondTeamScore) || !self.CheckIntScore(number: form.secondTeamScore)) {
            return MatchingResponse(isError: true , task: "Please enter number of score.")
        }
        
        if(form.startAt == form.endAt) {
            return MatchingResponse(isError: true , task: "Please Select start and end in different date.")
        }
        
        return self.error;
    }
    
    func createMatch (form : MatchingAgainst  , id : String ) -> CreateResponse{
        let isError = self.error
        let eventRef = db.collection("events").document(id)
        let matchRef = eventRef.collection("match").document();
        let startAt = Timestamp(date: form.startAt)
        let endAt = Timestamp(date : form.endAt)
        
        let firstTeam_Reference = db.collection("teams").document(form.firstTeam)
        let secondTeam_Reference = db.collection("teams").document(form.secondTeam)
        
        
        matchRef.setData([
            "fteam" : firstTeam_Reference,
            "fteam_score" : Int(form.firstTeamScore) ?? 0,
            "steam" : secondTeam_Reference ,
            "steam_score" : Int(form.secondTeamScore) ?? 0,
            "isEnd" : false,
            "startAt" : startAt,
            "endAt" :  endAt
        ])
        
        return CreateResponse(match_id: matchRef.documentID , response: isError)
    }
    
    func EditMatch (doc_id : String  , match_id : String  , information : MatchingEdit) -> MatchingResponse {
        let eventRef = db.collection("events").document(doc_id)
        let matchRef = eventRef.collection("match").document(match_id)
        
        if(!CheckIntScore(number: information.firstTeamScore) || !CheckIntScore(number: information.secondTeamScore)) {
            return MatchingResponse(isError: true , task: "Please enter number of score.")
        }
        
        matchRef.setData(["fteam_score" : Int(information.firstTeamScore) ?? 0 , "steam_score" : Int(information.secondTeamScore) ?? 0] , merge:true)
        
        return self.error
    }
    
    func BindingMatch (form : MatchingAgainst, id : String , match_id : String , completion : @escaping (Match) -> Void ) {
        let eventRef = db.collection("events").document(id)
        let matchRef = eventRef.collection("match").document(match_id);
        
        matchRef.getDocument{ query, error in
            guard let query  = query?.data() else { return }
            
            let firstTeam = query["fteam"] as! DocumentReference
            let secondTeam = query["steam"] as! DocumentReference
            
            var fteam : Teams?
            var steam : Teams?
            
            var matchDate =  ""
            var matchStart = ""
            
            if let timestamp = query["startAt"] as? Timestamp {
                 let date = timestamp.dateValue()
                 
                 let dateFormatter = DateFormatter()
                 dateFormatter.dateFormat = "EEE, MMMM d"

                 let timeFormatter = DateFormatter()
                 timeFormatter.dateFormat = "h:mm a"
                
                 matchDate = dateFormatter.string(from: date)
                 matchStart = timeFormatter.string(from: date)
            }

            
            firstTeam.getDocument{ fquery , error in
                guard let fquery = fquery?.data() else { return }
                let fteam_id = firstTeam.documentID as String
                let insertFirst = Teams(
                    id: fteam_id ,
                    name : fquery["name"] as! String ,
                    image : fquery["image"] as! String,
                    teams_text : fquery["teams_text"] as! String
                )
                fteam = insertFirst
            }
            
            secondTeam.getDocument{ squery , error in
                guard let squery = squery?.data() else { return }
                let steam_id = secondTeam.documentID as String
                let insertSecond = Teams(
                    id: steam_id ,
                    name : squery["name"] as! String ,
                    image : squery["image"] as! String,
                    teams_text : squery["teams_text"] as! String
                )
                steam = insertSecond
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let fteam = fteam, let steam = steam {
                    let matchItem = Match(
                        id: match_id,
                        fteam: fteam,
                        steam: steam,
                        fteam_score: query["fteam_score"] as! Int,
                        steam_score: query["steam_score"] as! Int,
                        matchDate: matchDate  ,
                        matchStart: matchStart,
                        isEnd : query["isEnd"] as? Bool ?? false
                    )
                    
                    completion(matchItem)
                }
            }
            
        }
    }
    
    func makeMatchEnd (doc_id : String , match_id : String) {
        let eventRef = db.collection("events").document(doc_id)
        let matchRef = eventRef.collection("match").document(match_id)
        
        matchRef.setData(["isEnd" : true] , merge : true)
    }
    
    func CheckIntScore (number : String) -> Bool{
        if Int(number) != nil {
            return true
        } else {
            return false
        }
    }
}
