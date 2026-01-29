//
//  RegisterViewModel.swift
//  iTRootsTask
//
//  Created by Ahmed Fathi on 27/01/2026.
//

import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    
    private let coordinator: Coordinator
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var isConfirmPasswordVisible: Bool = false
    
    @Published var fullNameError: String?
    @Published var emailError: String?
    @Published var phoneNumberError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?
    
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var registrationSuccess: Bool = false
    
    private let country: PhoneNumberCountry = .egypt
    private var cancellables = Set<AnyCancellable>()
    
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        setupValidation()
    }
    
    private func setupValidation() {
        $fullName
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] name in
                guard let self = self, !name.isEmpty else {
                    self?.fullNameError = nil
                    return
                }
                self.validateFullName()
            }
            .store(in: &cancellables)
        
        $email
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] email in
                guard let self = self, !email.isEmpty else {
                    self?.emailError = nil
                    return
                }
                self.validateEmail()
            }
            .store(in: &cancellables)
        
        $phoneNumber
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] phone in
                guard let self = self, !phone.isEmpty else {
                    self?.phoneNumberError = nil
                    return
                }
                self.validatePhoneNumber()
            }
            .store(in: &cancellables)
        
        $password
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] pwd in
                guard let self = self, !pwd.isEmpty else {
                    self?.passwordError = nil
                    return
                }
                self.validatePassword()
            }
            .store(in: &cancellables)
        
        $confirmPassword
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] confirmPwd in
                guard let self = self, !confirmPwd.isEmpty else {
                    self?.confirmPasswordError = nil
                    return
                }
                self.validateConfirmPassword()
            }
            .store(in: &cancellables)
    }
    
    var isFormValid: Bool {
        return fullNameError == nil &&
        emailError == nil &&
        phoneNumberError == nil &&
        passwordError == nil &&
        confirmPasswordError == nil &&
        !fullName.isEmpty &&
        !email.isEmpty &&
        !phoneNumber.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty
    }
    
    private func validateFullName() {
        fullNameError = FullNameValidator.getError(for: fullName)
    }
    
    private func validateEmail() {
        emailError = EmailValidator.getError(for: email)
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
        passwordError = PasswordValidator.getError(for: password, requireStrong: false)
        
        if !confirmPassword.isEmpty {
            validateConfirmPassword()
        }
    }
    
    private func validateConfirmPassword() {
        if confirmPassword.isEmpty {
            confirmPasswordError = "Please confirm your password"
        } else if password != confirmPassword {
            confirmPasswordError = "Passwords do not match"
        } else {
            confirmPasswordError = nil
        }
    }
    
    func register() {
        validateFullName()
        validateEmail()
        validatePhoneNumber()
        validatePassword()
        validateConfirmPassword()
        
        guard isFormValid else {
            return
        }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            
            let newUser = User(
                id: UUID().uuidString,
                fullName: self.fullName,
                email: self.email,
                phoneNumber: self.phoneNumber,
                password: self.password
            )
            
            UserDefaultsService.shared.saveUser(newUser)
            
            self.alertMessage = "Registration successful! Welcome, \(self.fullName)!"
            self.showAlert = true
            self.registrationSuccess = true
            
            print("User registered: \(self.email)")
        }
    }
    
    func togglePasswordVisibility() {
        isPasswordVisible.toggle()
    }
    
    func toggleConfirmPasswordVisibility() {
        isConfirmPasswordVisible.toggle()
    }
}
