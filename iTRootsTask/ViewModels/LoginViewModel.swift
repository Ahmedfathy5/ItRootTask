//
//  LoginViewModel.swift
//  iTRootsTask
//
//  Created by Ahmed Fathi on 27/01/2026.
//

import Foundation
import Combine

// MARK: - Login View Model
class LoginViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var phoneNumberError: String?
    @Published var passwordError: String?
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var loginSuccess: Bool = false
    
    // MARK: - Properties
    private let country: PhoneNumberCountry = .egypt
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        setupValidation()
    }
    
    // MARK: - Setup
    private func setupValidation() {
        // Real-time phone number validation
        $phoneNumber
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] phone in
                guard let self = self else { return }
                if !phone.isEmpty {
                    self.validatePhoneNumber()
                } else {
                    self.phoneNumberError = nil
                }
            }
            .store(in: &cancellables)
        
        // Real-time password validation
        $password
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] pwd in
                guard let self = self else { return }
                if !pwd.isEmpty {
                    self.validatePassword()
                } else {
                    self.passwordError = nil
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Computed Properties
    var formattedPhoneNumber: String {
        country.validator.format(phoneNumber)
    }
    
    var isFormValid: Bool {
        return phoneNumberError == nil &&
               passwordError == nil &&
               !phoneNumber.isEmpty &&
               !password.isEmpty
    }
    
    // MARK: - Validation Methods
    private func validatePhoneNumber() {
        let isValid = country.validator.validate(phoneNumber)
        
        if !isValid {
            if phoneNumber.count < country.phoneLength {
                phoneNumberError = "Phone number must be \(country.phoneLength) digits"
            } else if !phoneNumber.hasPrefix("01") {
                phoneNumberError = "Egyptian phone number must start with 01"
            } else {
                phoneNumberError = "Invalid Egyptian phone number format"
            }
        } else {
            phoneNumberError = nil
        }
    }
    
    private func validatePassword() {
        if password.count < 6 {
            passwordError = "Password must be at least 6 characters"
        } else {
            passwordError = nil
        }
    }
    
    // MARK: - Actions
    func signIn() {
        // Clear previous errors
        phoneNumberError = nil
        passwordError = nil
        
        // Validate all fields
        validatePhoneNumber()
        validatePassword()
        
        guard isFormValid else {
            return
        }
        
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            
            // Check if user exists in local storage
            if let savedUser = UserDefaultsService.shared.getUser() {
                if savedUser.phoneNumber == self.phoneNumber && savedUser.password == self.password {
                    self.alertMessage = "Welcome back, \(savedUser.fullName)!"
                    self.showAlert = true
                    self.loginSuccess = true
                    print("✅ User logged in: \(savedUser.email)")
                    return
                }
            }
            
            // Mock authentication for demo (you can remove this in production)
            if self.phoneNumber == "01234567890" && self.password == "password" {
                let demoUser = User(
                    id: UUID().uuidString,
                    fullName: "Demo User",
                    email: "demo@example.com",
                    phoneNumber: self.phoneNumber,
                    password: self.password
                )
                UserDefaultsService.shared.saveUser(demoUser)
                self.alertMessage = "Login successful!"
                self.showAlert = true
                self.loginSuccess = true
                print("✅ User logged in: \(self.phoneNumber)")
            } else {
                self.alertMessage = "Invalid phone number or password"
                self.showAlert = true
            }
        }
    }
    
    func register() {
        print("🔄 Navigate to registration screen")
    }
    
    func togglePasswordVisibility() {
        isPasswordVisible.toggle()
    }
    
    func clearErrors() {
        phoneNumberError = nil
        passwordError = nil
    }
}
