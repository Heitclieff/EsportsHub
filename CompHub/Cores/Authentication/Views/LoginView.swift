//
//  LoginView.swift
//  dockits
//
//  Created by Kittituch pulprasert on 28/3/2567 BE.
//
import SwiftUI

struct LoginView : View {
    @EnvironmentObject var validationModel : ValidationModel
    
    @Binding var isLogin : Bool
    @State private var email : String = ""
    @State private var password : String = ""
    
    @State private var Alertdialog = ""
    @State private var showingAlert = false
    
    var body : some View {
        VStack(alignment: .leading ,spacing :35) {
            VStack(alignment :.leading , spacing : 10) {
                Text("Login")
                    .font(.system(size : 26 , weight : .bold))
                Text("Welcome back to the app")
            }
            
            VStack(spacing : 25) {
                VStack (alignment: .leading) {
                    Text("Email Address").fontWeight(.semibold)
                    TextField("hello@example.com", text: $email).environment(\.isEnabled, true)
                        .textFieldStyle(.roundedBorder)
                }
                
                VStack (alignment: .leading) {
                    Text("Password").fontWeight(.semibold)
                    SecureField("Enter password", text: $password).environment(\.isEnabled, true)
                        .textFieldStyle(.roundedBorder)
                }
            }
            VStack (spacing  :25){
                Button{
                    let isError = validationModel.Loginvalidation(email: email, password : password)
                    
                    
                    
                    if(!isError.isError) {
                        validationModel.FindLoginAccount(email: email, password: password) {isError in
                            self.isLogin = true
                        }
                    }

                }label : {
                    Text("Login")
                        .frame(maxWidth : .infinity)
                        .padding(.all, 5)
                }
                    .buttonStyle(.borderedProminent)
                
                HStack {
                    VStack {
                        Divider()
                    }
                    Text("Or Sign in with").foregroundColor(.gray)
                    VStack {
                        Divider()
                    }
                }
                NavigationLink{
                    RegisterView()
                        .environmentObject(ValidationModel())
                }label : {
                    Text("Create an account")
                        .frame(maxWidth : .infinity)
                        .padding(.all, 5)
                }
            }
        }
        .padding()
        .alert(Alertdialog, isPresented: $showingAlert) {
                   Button("OK", role: .cancel) { }
        }
    }
}


//struct LoginView_preview : PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            LoginView(isLogin : false)
//                .environmentObject(ValidationModel())
//        }
//    }
//}


import Foundation
