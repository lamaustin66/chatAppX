//
//  LoginController.swift
//  chatAppX
//
//  Created by Austin Lam on 9/1/22.
//

import UIKit
import Firebase
import FirebaseDatabase


class LoginController: UIViewController {
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginOrRegister), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLoginOrRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form not valid")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password)
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            if error != nil {
                print(error)
                return
            }
            
            self.dismiss(animated: true)
        }
    }
    
    @objc func handleRegister() {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let uid = Auth.auth().currentUser?.uid
        else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            // Successfully authenticated user
            let ref = Database.database().reference()
            let userRef = ref.child("users").child(uid)
            userRef.updateChildValues(["name": name, "email": email]) { error, ref in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                self.dismiss(animated: true)
            }
            
        }
    }
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .loginControllerColor
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView() {
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        NSLayoutConstraint.activate([
            inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24),
        ])
        inputsContainerViewHeightAnchor?.isActive = true
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12),
            nameTextField.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -12),
            nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor),
        ])
        nameTextFieldHeightAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            nameSeparatorView.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12),
            nameSeparatorView.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -12),
            nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            nameSeparatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12),
            emailTextField.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -12),
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor)
        ])
        emailTextFieldHeightAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            emailSeparatorView.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12),
            emailSeparatorView.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -12),
            emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailSeparatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12),
            passwordTextField.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -12),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor)
        ])
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton() {
        NSLayoutConstraint.activate([
            loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12),
            loginRegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24),
            loginRegisterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupProfileImageView() {
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func setupLoginRegisterSegmentedControl() {
        NSLayoutConstraint.activate([
            loginRegisterSegmentedControl.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12),
            loginRegisterSegmentedControl.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -12),
            loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 25),
            loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12)
        ])
    }
}



extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
    }
    
    static var loginControllerColor: UIColor { return UIColor(r: 61, g: 91, b: 151) }
}
