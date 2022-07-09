//
//  CollectionVewController.swift
//  PhDProjectPractive
//
//  Created by Zhang Viana on 2021/3/1.
//

import UIKit
import Kommunicate

class ViewController: UIViewController{
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.center = CGPoint(x: view.bounds.size.width/2,
                                           y: view.bounds.size.height/2)
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
    }
    
    
    
    @IBAction func launchConversation(_ sender: Any) {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false

        Kommunicate.createAndShowConversation(from: self, completion: {
            error in
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            if error != nil {
                print("Error while launching")
            }
        })
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        Kommunicate.logoutUser { (result) in
            switch result {
            case .success(_):
                print("Logout success")
                self.dismiss(animated: true, completion: nil)
            case .failure( _):
                print("Logout failure, now registering remote notifications(if not registered)")
                if !UIApplication.shared.isRegisteredForRemoteNotifications {
                    UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                        if granted {
                            DispatchQueue.main.async {
                                UIApplication.shared.registerForRemoteNotifications()
                            }
                        }
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    
}
