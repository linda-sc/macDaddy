//
//  UserProfileVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 6/24/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import UIKit

class UserProfileVC: UIViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var optionsCollection: UICollectionView!
    @IBOutlet weak var optionsCollectionLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var background: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("UserProfile viewDidLoaded!~")
        optionsCollection.delegate = self
        optionsCollection.dataSource = self
        self.navigationController?.isNavigationBarHidden = true
        
        /*** Register cell nibs ***/
        optionsCollection.register(UINib.init(nibName: "BasicInfoCell", bundle: nil), forCellWithReuseIdentifier: "BasicInfoCell")
        optionsCollection.register(UINib.init(nibName: "GradeStatusCell", bundle: nil), forCellWithReuseIdentifier: "GradeStatusCell")
         optionsCollection.register(UINib.init(nibName: "BioCell", bundle: nil), forCellWithReuseIdentifier: "BioCell")
        optionsCollection.register(UINib.init(nibName: "MapCell", bundle: nil), forCellWithReuseIdentifier: "MapCell")
        optionsCollection.register(UINib.init(nibName: "LogoutCell", bundle: nil), forCellWithReuseIdentifier: "LogoutCell")
        
        
        //Set estimated item size
        if let flow = optionsCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        
        //Disappearing cells
        let flowLayout = BouncyLayout(style: .prominent)
        self.optionsCollection.setCollectionViewLayout(flowLayout, animated: true)
        
        //Set background based on Mac Status
        if UserManager.shared.currentUser?.status == "Daddy" {
            background.image = UIImage(named: "MacDaddy Background_Purple")
            
        }else {
            background.image = UIImage(named: "MacDaddy Background")

        }
        //Just dark mode.
        background.image = UIImage(named: "MacDaddy Background_DarkMode")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.optionsCollection!.reloadData()
        print ("viewWillAppear ACTIVATED!!!")
    }
}

extension UserProfileVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Switch the outcome based on the value of indexPath.row
        // aka decide which cell we render based on the row of the table
        switch indexPath.row {
            //In case we are looking at row 3, then execute this code
        case 0:
            let cell = optionsCollection.dequeueReusableCell(withReuseIdentifier: "BasicInfoCell", for: indexPath) as! BasicInfoCell
            cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            self.setStructure(for: cell)
            return cell
        case 1:
            let cell = optionsCollection.dequeueReusableCell(withReuseIdentifier: "GradeStatusCell", for: indexPath) as! GradeStatusCell
            cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            self.setStructure(for: cell)
            return cell
        case 2:
            let cell = optionsCollection.dequeueReusableCell(withReuseIdentifier: "BioCell", for: indexPath) as! BioCell
            //cell.parentViewController = self
            cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            self.setStructure(for: cell)
            return cell
        case 3:
            let cell = optionsCollection.dequeueReusableCell(withReuseIdentifier: "MapCell", for: indexPath) as! MapCell
            cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            self.setStructure(for: cell)
            return cell
        default:
            let cell = optionsCollection.dequeueReusableCell(withReuseIdentifier: "LogoutCell", for: indexPath) as! LogoutCell
            cell.parentViewController = self
            cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            self.setStructure(for: cell)
            return cell
        }
    }
    
    
    private func setStructure(for cell: UICollectionViewCell) {
        cell.layer.borderWidth = 20
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.cornerRadius = 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            //Basic Info Cell
            let width = view.bounds.width - 16
            let height: CGFloat = 200
            return CGSize(width: width, height: height)
        case 1:
            //Grade Status Cell
            let width = view.bounds.width - 16
            let height: CGFloat = 60
            return CGSize(width: width, height: height)
        case 2:
            //Bio Cell
            let width = view.bounds.width - 16
            let height: CGFloat = 100
            return CGSize(width: width, height: height)
        case 3:
            //Map Cell
            let width = view.bounds.width - 16
            let height: CGFloat = 300
            return CGSize(width: width, height: height)
            //Logout Cell
        default:
            let width = view.bounds.width - 16
            let height: CGFloat = 164
            return CGSize(width: width, height: height)
        }
    }
    
    /****************************************************************/
    // Estimates cell height
    /****************************************************************/
    func estimateFrameForText(text: String) -> CGRect {
        //we make the height arbitrarily large so we don't undershoot height in calculation
        let height: CGFloat = 1000
        //Set the width to the width of the text in the cell.
        let width: CGFloat = 250
        
        let size = CGSize(width: width, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "goToEditAvatar", sender: collectionView.cellForItem(at: indexPath))
        case 1:
            performSegue(withIdentifier: "goToEditGradeStatus", sender: collectionView.cellForItem(at: indexPath))
        case 2:
            performSegue(withIdentifier: "goToEditShortBio", sender: collectionView.cellForItem(at: indexPath))
        default:
            print("Did select item at index path")
        }
    }
}


