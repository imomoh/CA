//
//  CollectionViewExtention.swift
//  CrwdnApplication
//
//  Created by Ebuka Egbunam on 10/29/19.
//  Copyright © 2019 Ebuka Egbunam. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit


extension ViewController :  UICollectionViewDelegate , UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return crowdList.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! 
        CollectionViewCell
        cell.nameOfPlace.text = crowdList[indexPath.row].nameOfPlace
        
        return cell
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor =  UIColor.red.cgColor
    
        print("\(indexPath.row)")
        
        var Indexlatitude = crowdList[indexPath.row].lattitude
        var Indexlongitude = crowdList[indexPath.row].longitude
        let Indexcoordinate = CLLocationCoordinate2DMake(Indexlatitude, Indexlongitude)
        ZoomToLocation(coordinate: Indexcoordinate)
        print(Indexlatitude , Indexlongitude)
        
        
    }
       
       
    
    
}
