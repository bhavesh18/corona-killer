//
//  GameViewController.swift
//  CoronaKiller
//
//  Created by Bhavesh Sharma on 22/05/21.
//

import UIKit
import SpriteKit
//import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    
    var selectedSegmentIndex = 0
    let localData = SessionManager.i.localData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(SessionManager.i.localData.isLoggedIn){
            launchGame()
        }
        
        loginBtn.applyGradient(colours: [Colors.darkBlue, .gray])
    }
    
    
    func launchGame(){
        
        self.viewTopConstraint.constant = self.view.frame.height*2
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: {res in
            self.emptyFields()
            self.loginView.isHidden = true
            
            if let view = self.view as! SKView? {
                // Load the SKScene from 'GameScene.sks'
                if let scene = SKScene(fileNamed: "GameScene"){
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    // Present the scene
                    view.presentScene(scene)
                }
                
                view.ignoresSiblingOrder = true
                
                view.showsFPS = true
                view.showsNodeCount = true
                SessionManager.i.localData.isLoggedIn = true
                SessionManager.i.save()
            }
            
        })
    }
    
    func emptyFields(){
        usernameTF.text = ""
        emailTF.text = ""
        passwordTF.text = ""
        confirmPasswordTF.text = ""
    }
    
    func checkIfDetailsExists(email: String? = nil, username: String? = nil) -> Bool{
        var exist = false
        for d in localData.users {
            if(d.email == email || d.username == username){
                exist = true
            }
        }
        return exist
    }
    
    @IBAction func onLoginTap(_ sender: UIButton) {
        hideKeyboard()
        if(selectedSegmentIndex == 0){
            if(usernameTF.text == "" || passwordTF.text == ""){
                showAlert(msg: "Please fill all the fields")
            }else{
                
                if let index = SessionManager.i.getCurrentUserIndex(of: usernameTF.text!){
                    localData.currentUserIndex = index
                    SessionManager.i.save()
                    launchGame()
                }else{
                    showAlert(msg: "Invalid username!")
                }
            }
        }else{
            if(usernameTF.text == "" || emailTF.text == "" || passwordTF.text == "" || confirmPasswordTF.text == ""){
                showAlert(msg: "Please fill all the fields")
            }else{
                if(passwordTF.text != confirmPasswordTF.text){
                    showAlert(msg: "Password does not match")
                }else{
                    if(checkIfDetailsExists(email: emailTF.text!, username: usernameTF.text!)){
                        showAlert(msg: "Username or email exists")
                    }else{
                        localData.users.append(UserData(username: usernameTF.text!, email: emailTF.text!, password: passwordTF.text!, score: 0))
                        if let index = SessionManager.i.getCurrentUserIndex(of: usernameTF.text!){
                            localData.currentUserIndex = index
                        }
                        SessionManager.i.save()
                        launchGame()
                    }
                    
                }
            }
        }
        
    }
    
    @IBAction func onSegmentChange(_ sender: UISegmentedControl) {
        emptyFields()
        loginBtn.setTitle(sender.selectedSegmentIndex == 0 ? "LOGIN" : "SIGN UP", for: .normal)
        self.selectedSegmentIndex = sender.selectedSegmentIndex
        confirmPasswordTF.isHidden = sender.selectedSegmentIndex == 0
        emailTF.isHidden = sender.selectedSegmentIndex == 0
        hideKeyboard()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
