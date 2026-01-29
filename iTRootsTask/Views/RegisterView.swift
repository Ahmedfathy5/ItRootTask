//
//  RegisterView.swift
//  iTRootsTask
//
//  Created by Ahmed Fathi on 27/01/2026.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel: RegisterViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(viewModel: RegisterViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    Spacer(minLength: 40)
                    
                    VStack(spacing: 10) {
                        Image(systemName: "person.badge.plus.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)
                        
                        Text("Create Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Sign up to get started")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom, 20)
                    
                    // Full Name Field
                    FormField(
                        title: "Full Name",
                        icon: "person.fill",
                        placeholder: "John Doe",
                        text: $viewModel.fullName,
                        error: viewModel.fullNameError,
                        keyboardType: .default,
                        isSecure: false
                    )
                    
                    FormField(
                        title: "Email",
                        icon: "envelope.fill",
                        placeholder: "example@email.com",
                        text: $viewModel.email,
                        error: viewModel.emailError,
                        keyboardType: .emailAddress,
                        isSecure: false
                    )
                    .autocapitalization(.none)
                    
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
                    
                    SecureFormField(
                        title: "Password",
                        icon: "lock.fill",
                        placeholder: "Enter password",
                        text: $viewModel.password,
                        error: viewModel.passwordError,
                        isPasswordVisible: $viewModel.isPasswordVisible,
                        toggleAction: viewModel.togglePasswordVisibility
                    )
                    
                    SecureFormField(
                        title: "Confirm Password",
                        icon: "lock.fill",
                        placeholder: "Re-enter password",
                        text: $viewModel.confirmPassword,
                        error: viewModel.confirmPasswordError,
                        isPasswordVisible: $viewModel.isConfirmPasswordVisible,
                        toggleAction: viewModel.toggleConfirmPasswordVisibility
                    )
                    
                    Button(action: {
                        viewModel.register()
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            Text(viewModel.isLoading ? "Creating Account..." : "Register")
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
                    
                    // Already have account button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(.white)
                            Text("Sign In")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                        .font(.subheadline)
                    }
                    .padding(.top, 10)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Registration"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK")) {
                    if viewModel.registrationSuccess {
                        
                    }
                }
            )
        }
    }
}

struct FormField: View {
    let title: String
    let icon: String
    let placeholder: String
    @Binding var text: String
    let error: String?
    let keyboardType: UIKeyboardType
    let isSecure: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(error != nil ? Color.red : Color.clear, lineWidth: 2)
            )
            
            if let error = error {
                ErrorText(error: error)
            }
        }
        .padding(.horizontal, 30)
    }
}

struct SecureFormField: View {
    let title: String
    let icon: String
    let placeholder: String
    @Binding var text: String
    let error: String?
    @Binding var isPasswordVisible: Bool
    let toggleAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                
                if isPasswordVisible {
                    TextField(placeholder, text: $text)
                } else {
                    SecureField(placeholder, text: $text)
                }
                
                Button(action: toggleAction) {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(error != nil ? Color.red : Color.clear, lineWidth: 2)
            )
            
            if let error = error {
                ErrorText(error: error)
            }
        }
        .padding(.horizontal, 30)
    }
}

struct ErrorText: View {
    let error: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.circle.fill")
                .font(.caption)
            Text(error)
                .font(.caption)
        }
        .foregroundColor(.red)
        .padding(.leading, 5)
    }
}
