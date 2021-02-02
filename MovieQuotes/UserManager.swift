//
//  UserManager.swift
//  MovieQuotes
//
//  Created by Haoxuan Sun on 2/2/21.
//

import Foundation
import Firebase

let kCollectionUsers = "Users"
let kKeyName = "name"
let kPhotoUrl = "photoUrl"

class UserManage {
    var _collectionRef: CollectionReference
    var _document: DocumentSnapshot?
    var _userListener: ListenerRegistration?
    
    static let shared = UserManage()
    private init() {
        _collectionRef = Firestore.firestore().collection(kCollectionUsers)
    }

    //Creat
    func addNewUserMaybe(uid:String, name: String?, photoUrl: String?){
        //Get the user to see they exists
        //Add User only if they not exist
        let userRef = _collectionRef.document(uid)
        userRef.getDocument { (documentSnapshot, error) in
            if let error = error{
                print("Error geting user \(error)")
                return
            }
            if let documentSnapshot = documentSnapshot{
                if documentSnapshot.exists{
                    print("There is already a user for this user")
                    return
                }else{
                    print("Creating a User with document \(uid)")
                    userRef.setData([
                        kKeyName: name ?? "",
                        kPhotoUrl: photoUrl ?? ""
                    ])
                }
            }
        }
    }
    //Read
    func beginListening(uid:String, changeListener: () -> Void){
        
    }
    func stopListening(){
        _userListener?.remove()
    }
    //update
    func updateName(name: String){
        
    }
    func updatePhotoUrl(photoUrl: String){
        
    }
    
    //Delete -- no delete
    
    //Gitters
    var name: String{
       
        if let value = _document?.get(kKeyName){
            return value as! String
        }
        return ""
    }
        
    
}
