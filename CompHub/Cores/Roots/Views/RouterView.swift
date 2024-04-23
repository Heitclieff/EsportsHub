//
//  RouterView.swift
//  CompHub
//
//  Created by Kittituch pulprasert on 23/4/2567 BE.
//

import SwiftUI

struct RouterView  : View {
    @State var isLogin = false
    var body: some View {
        NavigationStack {
            if(isLogin) {
                Tabview(isLogin : $isLogin)
                    .environmentObject(EventViewModel())
            }else {
                LoginView(isLogin : $isLogin)
                    .environmentObject(ValidationModel())
            }
        }
        .tint(.pink)
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            let id = UserDefaults.standard.string(forKey: "user_id")
        
            if(id!.isEmpty) {
                self.isLogin = false
            }else {
                self.isLogin = true
            }
          }
    }
   
        
}

struct RouterView_previews : PreviewProvider {
    static var previews: some View {
        RouterView()
    }
}
