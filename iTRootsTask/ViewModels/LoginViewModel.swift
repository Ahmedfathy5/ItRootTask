//
//  LoginViewModel.swift
//  iTRootsTask
//
//  Created by Ahmed Fathi on 27/01/2026.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    
    let coordinator: AppCoordinator
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var phoneNumberError: String?
    @Published var passwordError: String?
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var loginSuccess: Bool = false
    
    private let country: PhoneNumberCountry = .egypt
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        setupValidation()
    }
    
    private func setupValidation() {
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
    
    var formattedPhoneNumber: String {
        country.validator.format(phoneNumber)
    }
    
    var isFormValid: Bool {
        return phoneNumberError == nil &&
        passwordError == nil &&
        !phoneNumber.isEmpty &&
        !password.isEmpty
    }
    
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
    
    func signIn() {
        phoneNumberError = nil
        passwordError = nil
        
        validatePhoneNumber()
        validatePassword()
        
        guard isFormValid else {
            return
        }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            
            if let savedUser = UserDefaultsService.shared.getUser() {
                if savedUser.phoneNumber == self.phoneNumber && savedUser.password == self.password {
                    // Ensure login state is persisted
                    UserDefaultsService.shared.saveUser(savedUser)
                    
                    self.alertMessage = "Welcome back, \(savedUser.fullName)!"
                    self.showAlert = true
                    self.loginSuccess = true
                    return
                }
            }
            
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
            } else {
                self.alertMessage = "Invalid phone number or password"
                self.showAlert = true
            }
        }
    }
    
    func navigateToRegisterView() {
        coordinator.showRegister()
    }
    
    func togglePasswordVisibility() {
        isPasswordVisible.toggle()
    }
    
    func clearErrors() {
        phoneNumberError = nil
        passwordError = nil
    }
}
