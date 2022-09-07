//
//  LoginController+handlers.swift
//  chatAppX
//
//  Created by Austin Lam on 9/6/22.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageView.image = editedImage
        }
        
        dismiss(animated: true)
    }
    
    @objc func handleRegister() {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let profileImageData = profileImageView.image?.pngData()
        else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            
            // Successfully authenticated user
            let storageRef = Storage.storage().reference().child("profileImages").child(UUID().uuidString)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storageRef.putData(profileImageData, metadata: metadata) { metaData, error in
                guard error == nil else {
                    print("error")
                    return
                }
                
                guard let profileImageUrl = metaData?.path else {
                    print("no profileImageUrl")
                    return
                }
                
                let values: [String: Any] = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                self.registerUserIntoDatabase(uid: uid, values: values)
            }
            
        }
    }
    
    private func registerUserIntoDatabase(uid: String, values: [String: Any]) {
        let databaseRef = Database.database().reference()
        let userRef = databaseRef.child("users").child(uid)
        userRef.updateChildValues(values) { error, ref in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            self.dismiss(animated: true)
        }
    }
}
