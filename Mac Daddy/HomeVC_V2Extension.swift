//
//  HomeVC_V2Extension.swift
//  Mac Daddy
//
//  Created by Linda Chen on 2/10/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import Foundation
import Firebase

extension HomeVC {
    
    //MARK: Called in ViewDidLoad
    
    func viewDidLoadExtension() {

        UserManager.shared.getLocation()
        UserRequests().checkupUpdates()
        self.refreshActivity()
        setUpCollectionView()
        
        //Add observer to trigger reload
        NotificationCenter.default.addObserver(self, selector: #selector(onDidRecieveUpdatedFriendshipObjects(_:)), name: .onDidRecieveUpdatedFriendshipObjects, object: nil)
    }
    
    func setUpCollectionView() {
        friendshipCollection.delegate = self
        friendshipCollection.dataSource = self
        
        //Register Nibs
        friendshipCollection.register(UINib.init(nibName: "FriendshipCell", bundle: nil), forCellWithReuseIdentifier: "FriendshipCell")
        
        //Set layout
        if let flow = friendshipCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        let flowLayout = BouncyLayout(style: .prominent)
        self.friendshipCollection.setCollectionViewLayout(flowLayout, animated: true)
        
    }
    
    //MARK: Function called when logo tapped
    func refreshActivity() {
        if let myFriendships = UserManager.shared.friendships {
            FriendshipRequests().updateMyLastActiveStatusInAllFriendships(becomingActive: true)
            self.updatedActiveStatusOnce = true
        }
    }

    //MARK: Stuff to do when objects update

    @objc func onDidRecieveUpdatedFriendshipObjects(_ notification:Notification) {
        print("FriendshipObjects updated")
        self.tableView.reloadData()
        self.friendshipCollection.reloadData()
    }
    
    
    //MARK: Delete friendship
    func deleteFriendship(friendship: FriendshipObject) {
        FriendshipRequests().archiveFriendshipObject(friendship: friendship, completion: { (success) in
            if success {
              UserManager.shared.friendships?.removeAll(where: {$0.convoId == friendship.convoId})
            } else {
                print("Error deleting friendship")
            }
        })
    }
}



//MARK: CollectionView
extension HomeVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserManager.shared.friendships?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = friendshipCollection.dequeueReusableCell(withReuseIdentifier: "FriendshipCell", for: indexPath) as! FriendshipCell
        cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        if let friendship = UserManager.shared.friendships?[indexPath.row] {
            //First update with friendshp
            cell.update(with: friendship)
            //Then update with friend if possible.
            let friendUid = FriendshipRequests().getFriendsUid(friendship: friendship)
            if let friend = FriendshipRequests().fetchCachedFriendStruct(uid: friendUid) {
                cell.update(with: friend)
            }
            
        }
        
        self.setStructure(for: cell)
        return cell
    }
    
    private func setStructure(for cell: UICollectionViewCell) {
          cell.layer.borderWidth = 20
          cell.layer.borderColor = UIColor.clear.cgColor
          cell.layer.cornerRadius = 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
               let width = view.bounds.width
               let height: CGFloat = 80
               return CGSize(width: width, height: height)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Did select item at.")
    }
    
}


//MARK: Segues

extension HomeVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {


        if segue.identifier == "ChatWithFriend" {
            let destination = segue.destination as! ChatSceneVC
            if let selectedRow = friendshipCollection.indexPathsForSelectedItems?.first?.row {
                if let friendship = UserManager.shared.friendships?[selectedRow] {
                    destination.friendship = friendship
                    
                    let friendUid = FriendshipRequests().getFriendsUid(friendship: friendship)
                    
                    if let friend = FriendshipRequests().fetchCachedFriendStruct(uid: friendUid) {
                        destination.friend = friend
                    }
                }
                
            } else {
                let friend = self.currentMatch
                destination.friend = friend
                if let friendship = FriendshipRequests().fetchCachedFriendship(uid: friend.uid) {
                    destination.friendship = friendship
                }
            }
        }

        else if segue.identifier == "PresentNewMatch" {
            let destination = segue.destination as! ChatSceneVC
            self.currentMatch.anon = "1"
            destination.friend = self.currentMatch
            //destination.friendship =
            
        } else {
            if let selectedIndexPath = friendshipCollection.indexPathsForSelectedItems?.first.row {
                friendshipCollection.deselectItem(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromDetail(segue: SegueToLeft) {
        self.matchBox.isEnabled = true
        self.matchBox.setTitle( "Find a match!", for: .normal)
        
        let source = segue.source as! ChatSceneVC
        if let selectedIndexPath = friendshipCollection.indexPathsForSelectedItems?.first?.row {
            UserManager.shared.friendships?[selectedIndexPath.row] = source.friend
            friendshipCollection.reloadItems(at: [selectedIndexPath])

        } else {
            let newIndexPath = IndexPath(row: 0, section:0)
            
            //Only add the friend to the list if they are a new friend.
            var newFriend = true
            for friend in DataHandler.friendList {
                if source.friend.convoID == friend.convoID {
                    newFriend = false
                }
            }
            if newFriend {
                DataHandler.friendList.append(source.friend)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
                tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromBlock(segue: SegueToLeft) {
        self.matchBox.isEnabled = true
        self.matchBox.setTitle( "Find a match!", for: .normal)
        
        friendshipCollection.reloadData()
    }

}