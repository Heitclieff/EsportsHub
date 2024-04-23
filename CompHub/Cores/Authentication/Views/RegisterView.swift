//
//  RegisterView.swift
//  CompHub
//
//  Created by Kittituch pulprasert on 22/4/2567 BE.
//

import Foundation
import SwiftUI

struct RegisterView : View {
    @EnvironmentObject var validationModel : ValidationModel
    @Environment(\.presentationMode) var presentationMode
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""

    @State private var Alertdialog = ""
    @State private var showingAlert = false
    
    var body : some View {
        VStack  {
            Text("Register")
            VStack {
                VStack (alignment: .leading) {
                    Text("Username").fontWeight(.semibold)
                    TextField("Enter your username", text: $username).environment(\.isEnabled, true)
                        .textFieldStyle(.roundedBorder)
                }
                VStack (alignment: .leading) {
                    Text("Email").fontWeight(.semibold)
                    TextField("hello@example.com", text: $email).environment(\.isEnabled, true)
                        .textFieldStyle(.roundedBorder)
                }
                VStack (alignment: .leading) {
                    Text("Password").fontWeight(.semibold)
                    SecureField("password", text: $password).environment(\.isEnabled, true)
                        .textFieldStyle(.roundedBorder)
                }
                Button() {
                    let isError = validationModel.RegisterValidation(username: username, email: email, password: password)
                    
                    self.showingAlert = isError.isError
                    self.Alertdialog = isError.task
                    
                    if(!isError.isError) {
                       validationModel.Registerusers(username: username, email: email, password: password)
                        presentationMode.wrappedValue.dismiss()
                    }
                }label : {
                    Text("Register")
                        .frame(maxWidth : .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top , 20)
                
            }
        }
        .navigationTitle("Register")
        .padding()
        .alert(Alertdialog, isPresented: $showingAlert) {
                   Button("OK", role: .cancel) { }
        }
    }
}

struct RegisterView_preview : PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(ValidationModel())
    }
}


