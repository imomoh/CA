//
//  CardViewController.swift
//  CrwdnApplication
//
//  Created by Ebuka Egbunam on 10/11/19.
//  Copyright © 2019 Ebuka Egbunam. All rights reserved.
//

import UIKit

class CardViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource {
   

     let  cellIdentifier = "realCell"
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionView.dataSource = self
        //collectionView.delegate = self
//         self.collectionView.register(UINib(nibName:"CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)

        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return  10
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
          let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
           return cell
           
       }
       

    
    
    
    


    @IBOutlet weak var handleArea: UIView!
   

}
