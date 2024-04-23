import SwiftUI

struct AccountView: View {
    @Binding var isLogin : Bool
    @Binding var tabbarColor : UIColor
    @State private var accountItem: [AccEvent] = []
    @State private var showingCredits  = false
    @State private var showingPreferance = false
    var profileimage = "https://preview.redd.it/pz2riusi3cc51.jpg?auto=webp&s=5177dc60f73c0290e58b89fd4c32007db977d8bd"
    
    func resetView () {
        showingPreferance = false
    }
    var body: some View {
                VStack(alignment : .leading) {
                    ScrollView {
                        Spacer(minLength: 25)
                        
                        if(!accountItem.isEmpty) {
                            Button {
                                showingCredits = true
                            }label :{
                                VStack () {
                                    VStack {
                                        AsyncImage(url : URL(string : accountItem[0].account.image)) { image in
                                            image.resizable()
                                                .aspectRatio(contentMode : .fit)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 200, height: 200)
                                        .clipped()
                
                                    }
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .clipped()
                
                                    Text(accountItem[0].account.name)
                                    Text(accountItem[0].account.email)
                                        .font(.system(size : 14  , design : .default))
                
                                }
                                .foregroundColor(.black)
                            }
                         
                        }
                                       
                        
                        Spacer(minLength: 45)
                        
                        
                        VStack (alignment : .leading) {
                            if(!accountItem.isEmpty){
                                HStack {
                                    Text("My Event")
                                        .font(.system(size : 24 ,weight : .bold , design : .default))
                                    Spacer()
                                    NavigationLink{
                                        CreateEventView(event :  $accountItem[0]).environmentObject(EventViewModel())
                                    }label : {
                                            Text("New")
                                        }
                                    
                                }
                            }
                            
                            if(!accountItem.isEmpty) {
                                VStack(alignment : .leading) {
                                    ForEach(accountItem[0].myevents) { ev in
                                        NavigationLink {
                                            EventView(event : ev)
                                        }label : {
                                            EventCardView(event: ev)
                                        }
                                        
                                    }
                                }
                            }
                         
                        }

                    }
                    .padding(1.0)
                  
                    .sheet(isPresented : $showingCredits){
                        
                                List {
                                    Button ()  {
                                        showingPreferance.toggle()
                                    } label : {
                                        Label("Preferance", systemImage: "person.crop.circle")
                                            .foregroundColor(.black)
                                    }
                                    Button {
                                        self.isLogin = false
                                        UserDefaults.standard.set("" , forKey: "user_id")
                                        showingCredits = false
                                    } label: {
                                        Label("Sign out", systemImage: "door.right.hand.open")
                                            .foregroundColor(.red)
                                    }
                                }
                                
                              
                            .presentationDetents([.height(150)])
                           
                            .sheet(isPresented : $showingPreferance) {
                                NavigationStack {
                                    InformationView(account : $accountItem[0])
                                        .environmentObject(AccountModel())
                                        .toolbar {
                                           
                                            ToolbarItem(placement: .navigationBarTrailing) {
                                                Button("Done") {
                                                    showingPreferance = false
                                                }
                                            }
                                        }
                                    
                                }
                            }
                    }
                }
                .padding()
                .onAppear {
                   let id = UserDefaults.standard.string(forKey: "user_id") ?? ""
                   AccountModel().fetchAccount(id: id) { recivedItem in
                       self.accountItem = recivedItem
                       self.tabbarColor = .gray
                    }
                }
        
    }
       
}
//struct AccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            AccountView()
//                .environmentObject(AccountModel())
//        }
//
//    }
//}
