//
//  LoginView.swift
//  iTRootsTask
//
//  Created by Ahmed Fathi on 27/01/2026.
//

import SwiftUI

// MARK: - Login View
struct LoginView: View {
    
    @EnvironmentObject var localizationManager: LocalizationManager

    @StateObject private var viewModel = LoginViewModel()
    @State private var showRegister = false
    @State private var navigateToMain = false
    @State private var isRegistrationSuccess = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 25) {
                        Spacer(minLength: 60)
                        
                        // App Logo/Title
                        VStack(spacing: 10) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.white)
                            
                            Text("Welcome Back")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Sign in to continue")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.bottom, 40)
                        
                        // Phone Number Field
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Phone Number")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                Text("🇪🇬 +20")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            HStack {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.gray)
                                
                                TextField("01X XXXX XXXX", text: $viewModel.phoneNumber)
                                    .keyboardType(.phonePad)
                                    .autocapitalization(.none)
                                    .onChange(of: viewModel.phoneNumber) { newValue in
                                        let filtered = newValue.filter { $0.isNumber }
                                        if filtered.count > 11 {
                                            viewModel.phoneNumber = String(filtered.prefix(11))
                                        } else {
                                            viewModel.phoneNumber = filtered
                                        }
                                    }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(viewModel.phoneNumberError != nil ? Color.red : Color.clear, lineWidth: 2)
                            )
                            
                            if let error = viewModel.phoneNumberError {
                                ErrorText(error: error)
                            }
                        }
                        .padding(.horizontal, 30)
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.gray)
                                
                                if viewModel.isPasswordVisible {
                                    TextField("Enter password", text: $viewModel.password)
                                } else {
                                    SecureField("Enter password", text: $viewModel.password)
                                }
                                
                                Button(action: {
                                    viewModel.togglePasswordVisibility()
                                }) {
                                    Image(systemName: viewModel.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(viewModel.passwordError != nil ? Color.red : Color.clear, lineWidth: 2)
                            )
                            
                            if let error = viewModel.passwordError {
                                ErrorText(error: error)
                            }
                        }
                        .padding(.horizontal, 30)
                        
                        // Sign In Button
                        Button(action: {
                            viewModel.signIn()
                        }) {
                            HStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                }
                                Text(viewModel.isLoading ? "Signing In..." : "Sign In")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isFormValid ? Color.green : Color.gray)
                            .cornerRadius(12)
                            .shadow(color: viewModel.isFormValid ? Color.green.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
                        }
                        .disabled(!viewModel.isFormValid || viewModel.isLoading)
                        .padding(.horizontal, 30)
                        .padding(.top, 10)
                        
                        // Register Button
                        Button(action: {
                            showRegister = true
                        }) {
                            Text("Register")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                        .padding(.horizontal, 30)
                        .disabled(viewModel.isLoading)
                        
                        Spacer(minLength: 40)
                    }
                }
                .overlay(alignment: .topTrailing) {
                    Button {
                        localizationManager.appLanguage =
                        localizationManager.appLanguage == "en" ? "ar" : "en"
                    } label: {
                        Text(localizationManager.appLanguage == "en" ? "AR" : "EN")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(10)
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 10)

                }
                
                // Navigation Links
                NavigationLink(destination: MainView(isLoggedIn: $navigateToMain), isActive: $navigateToMain) {
                    EmptyView()
                }
                
                NavigationLink(destination: RegisterView(isRegistrationSuccess: $isRegistrationSuccess), isActive: $showRegister) {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Login"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if viewModel.loginSuccess {
                            navigateToMain = true
                        }
                    }
                )
            }
            .onChange(of: isRegistrationSuccess) { success in
                if success {
                    navigateToMain = true
                    isRegistrationSuccess = false
                }
            }
        }
    }
}

// MARK: - Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
