//
//  SlideViewAnimations.swift
//  CrwdnApplication
//
//  Created by Ebuka Egbunam on 10/29/19.
//  Copyright © 2019 Ebuka Egbunam. All rights reserved.
//

import Foundation
import UIKit


extension ViewController{
    
    
    
    func setUpCard(){
        
        setupViewLook()
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(recogonizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(recognizer:)))
        
        
        
        gestureView.addGestureRecognizer(tapGestureRecognizer)
        gestureView.addGestureRecognizer(panGestureRecognizer)
        
        
        
    }
    @objc
    func handleTap(recogonizer : UITapGestureRecognizer){
        switch recogonizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
            
        default:
            break
        }
        
    }
    
    
    @objc
    func handlePan(recognizer : UIPanGestureRecognizer){
        switch recognizer.state {
        case .began:
            startTrans(state: nextState, duration: timeInterval)
        case .changed:
            let translation = recognizer.translation(in: self.gestureView)
            var fractionCompleted = translation.y  / self.gestureView.frame.height
            fractionCompleted = cardVisible ? fractionCompleted : -fractionCompleted
            updateTrans(fractionCompleted:fractionCompleted)
            
        case .ended:
            continuetrans()
        default:
            break
        }
        
    }
    
    
    func animateTransitionIfNeeded( state : cardState , duration :TimeInterval){
        if runningAnimations.isEmpty{
            // animating view
            let viewAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                
                switch state{
                case .expanded:
                    
                    //self.viewAdd.frame = CGRect(x: 0, y: 800, width: 414, height: 285)
                    self.viewAdd.transform = CGAffineTransform(translationX: 0, y: CGFloat(self.cardTransformHeightWhenCollapsed))
                    
                case .collapsed:
                    
                   // self.viewAdd.frame = CGRect(x: 0, y: 635, width: 414, height: 285)
                    
                    
                    self.viewAdd.transform = CGAffineTransform(translationX: 0, y: CGFloat(self.cardTransformHeightWhenExpanded))
                    
                }
                
                
            }
            
            viewAnimator.addCompletion { (_) in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            viewAnimator.startAnimation()
            runningAnimations.append(viewAnimator)
            
            
            
            
            
            
            
            
            
            
            
            //animate conner radius
            let connerRadius = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state{
                case .collapsed:
                    self.viewAdd.layer.cornerRadius = 0
                case .expanded:
                    self.viewAdd.layer.cornerRadius = 20
                    
                }
            }
            
            connerRadius.startAnimation()
            runningAnimations.append(connerRadius)
            
            
            
            // animating self.view : expaneded the view reduces in width and vice versa
            
            
            let selfViewAnimation = UIViewPropertyAnimator(duration: 0.45, curve: .linear) {
                switch state{
                case .collapsed:
                    //return to original height
                    self.mapView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.view.backgroundColor = .white
                case .expanded:
                    // reduce size
                    self.mapView.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
                    self.view.backgroundColor = .black
                    
                }
            }
            
            selfViewAnimation.startAnimation()
            runningAnimations.append(selfViewAnimation)
            
            //MARK:-  animate stack
            
            
                        let stackAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio:1) {
                            switch state{
                            case .expanded:
                                
                                
                                self.animatedStack.transform = CGAffineTransform(translationX: 0, y: CGFloat(self.cardTransformHeightWhenCollapsed))
            
                            case .collapsed:
                                self.animatedStack.transform = CGAffineTransform(translationX: 0, y: CGFloat(self.cardTransformHeightWhenExpanded))
            
                            }
                        }
            
                        stackAnimator.startAnimation()
                        runningAnimations.append(stackAnimator)
            
            //buttonanimator ended
            //
            //            let positionButtonAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio:1) {
            //                switch state{
            //                case .collapsed:
            //                    self.positionOutlet.transform = CGAffineTransform(translationX: 0, y: -(self.positionOutlet.frame.height - 64))
            //
            //                case .expanded:
            //                    self.positionOutlet.transform = CGAffineTransform(translationX: 0, y: -(self.cardHeight - self.positionOutlet.frame.height + 9))
            //
            //                }
            //            }
            //
            //            positionButtonAnimator.startAnimation()
            //            runningAnimations.append(positionButtonAnimator)
            //
            //
            
        }
        
    }
    
    func startTrans(state : cardState , duration : TimeInterval){
        if runningAnimations.isEmpty{
            animateTransitionIfNeeded(state: state, duration: duration)
            
        }
        for animator in runningAnimations{
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete + animationProgressWhenInterrupted
        }
        
        
    }
    
    func updateTrans(fractionCompleted : CGFloat){
        
        for animator in runningAnimations{
            animator.fractionComplete = fractionCompleted
        }
        
    }
    
    func continuetrans (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
        
    }
}

