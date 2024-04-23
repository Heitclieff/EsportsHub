//
//  Event.swift
//  dockits
//
//  Created by Kittituch pulprasert on 24/3/2567 BE.
//

import Foundation

struct Event : Identifiable {
    var id : String?
    var title : String
    var images : String
}


struct Players : Identifiable {
    var id = UUID()
    var image : String
    var name : String
    var teams : String
    var regions : String
}

struct Teamstype : Identifiable  {
    var id : String
    var teams : String
    var image : String
    var players : [Any]
}

var EventList = [
    Event(
        id : "1",
        title: "Festival Event" ,
        images : "https://c.wallhere.com/photos/90/fd/Makima_Chainsaw_Man_closeup_tie_eyes_red_background-2269634.jpg!d"
    ),
    Event(
        id : "2",
        title: "Valorant pacific kickoff" ,
        images : "https://images.contentstack.io/v3/assets/bltb6530b271fddd0b1/bltcc57e72a595fbd95/65e128246e7edbc498b508b0/VCT24_Masters_Madrid_PromoFilm_Thumb_textless.png?auto=webp&disable=upscale&height=1055"
    )
]


var PlayerList = [Teamstype(
    id : "sen",
    teams : "Sentinels" ,
    image : "https://upload.wikimedia.org/wikipedia/pt/thumb/f/ff/Sentinels-logo.png/150px-Sentinels-logo.png",
    players : [
        Players(
            image : "https://owcdn.net/img/6416956f0da1e.png",
            name : "zekken",
            teams : "SEN",
            regions: "America"
        ),
        Players(
            image : "https://owcdn.net/img/65622aa13dc03.png",
            name : "johnqt",
            teams : "SEN",
            regions: "Morroco"
        ),
        Players(
            image : "https://owcdn.net/img/6416950ce6638.png",
            name : "Tenz",
            teams : "SEN",
            regions: "Canada"
        ),
        Players(
            image : "https://owcdn.net/img/6416954a0788d.png",
            name : "Sacy",
            teams : "SEN",
            regions: "Brazil"
        ),
        Players(
            image : "https://owcdn.net/img/64168e9618e29.png",
            name : "Zellsis",
            teams : "SEN",
            regions: "America"
        ),
    ]
),
    Teamstype(
        id : "prx",
        teams : "Paper Rex",
        image : "https://yt3.googleusercontent.com/G9wLES45hXFXw4TkG1_Y529MKr227cgdyNgzNZ4zNqDdn7Z1J1bcon1opO4b59AlGjHaFEBVSQ=s900-c-k-c0x00ffffff-no-rj",
    players : [
        Players(
            image : "https://owcdn.net/img/65c51572ead91.png",
            name : "Monyet",
            teams : "PRX",
            regions: "Indonisia"
        ),
        Players(
            image : "https://owcdn.net/img/65c51551ccd1d.png",
            name : "mindfreak",
            teams : "PRX",
            regions: "Indonisia"
        ),
        Players(
            image : "https://owcdn.net/img/65c5156b87691.png",
            name : "something",
            teams : "PRX",
            regions: "Russia"
        ),
        Players(
            image : "https://owcdn.net/img/65c5155a0e52e.png",
            name : "f0rsakeN",
            teams : "PRX",
            regions: "Indonisia"
        ),
        Players(
            image : "https://owcdn.net/img/65c515629bfb2.png",
            name : "d4v41",
            teams : "PRX",
            regions: "Malaysia"
        )
    ]
  )
]


