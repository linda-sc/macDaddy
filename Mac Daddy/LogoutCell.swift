//
//  LogoutCell.swift
//  Mac Daddy
//
//  Created by Linda Chen on 6/24/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import UIKit

class LogoutCell: UICollectionViewCell {

    var parentViewController : UserProfileVC?
    @IBOutlet weak var backButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backButton.clipsToBounds = true
        backButton.layer.cornerRadius = 15
    }
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        print("logoutTapped")
        FirebaseManager.logout{
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "OnboardingNavigationVC")
            controller.modalPresentationStyle = .fullScreen
            self.parentViewController?.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.parentViewController?.dismiss(animated: true, completion: nil)
    }
    
}
