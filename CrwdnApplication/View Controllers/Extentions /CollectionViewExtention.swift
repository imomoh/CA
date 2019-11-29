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
        cell.distanceInMiles.text = crowdList[indexPath.row].distanceFromCurrentLocation
        
        //DownloadImage(imageURL: "https://image.blockbusterbd.net/00416_main_image_04072019225805.png")
        //chnagingImage?.resizeImage(cell.snapButtonOutlet.frame.height, opaque: false)
        // replace image url with imageurl from  indexpath.row
        //cell.snapButtonOutlet.setBackgroundImage(chnagingImage, for: .normal)
        //cell.snapImage.image = chnagingImage
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


extension UIImage  {
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode:
        UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage

        let size = self.size
        let aspectRatio =  size.width/size.height

        switch contentMode {
        case .scaleAspectFit:
            if aspectRatio > 1 {                            // Landscape image
                width = dimension
                height = dimension / aspectRatio
            } else {                                        // Portrait image
                height = dimension
                width = dimension * aspectRatio
            }

        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }

        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }

        return newImage
    }
}

extension CALayer {
    func addGradientBorder(colors:[UIColor],width:CGFloat = 1 , frame: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(origin: CGPoint.zero, size: self.bounds.size)
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.0)
        gradientLayer.endPoint = CGPoint(x:1.0,y:1.0)
        gradientLayer.colors = colors.map({$0.cgColor})

        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(rect: self.bounds).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.red.cgColor
        gradientLayer.mask = shapeLayer

        self.addSublayer(gradientLayer)
    }
}



