//
//  Obstacles.swift
//  Plane
//
//  Copyright © 2017 Francesca Cuda. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class Obstacles {
    
    let purpleObject:SCNNode
    let orangeObject:SCNNode
    let redObject:SCNNode
    
    let moveAction:SCNAction
    
    init() {
        let geometryScene = SCNScene(named: "art.scnassets/Geometry.dae")!
        purpleObject = geometryScene.rootNode.childNode(withName: "Purple", recursively: true)!
        orangeObject = geometryScene.rootNode.childNode(withName: "Orange", recursively: true)!
        redObject = geometryScene.rootNode.childNode(withName: "Red", recursively: true)!
        
        moveAction = SCNAction.move(by: SCNVector3(0,0,50), duration: 5)
    }
    
    func spawnObstacles(nodeToAddTo: SCNNode){
        var obstacle: SCNNode
        var xPosition:Float = (Float(arc4random_uniform(5)) * -2.0) + 2.0
        if xPosition == 0 {
            xPosition = 2
        }
        let yPosition:Float = (Float(arc4random_uniform(4)) * -1.0) + 2.0
        let vector = SCNVector3(x: xPosition, y: yPosition, z: -50)
        
        switch arc4random_uniform(3) {
        case 0:
            obstacle = purpleObject.clone()
        case 1:
            obstacle = orangeObject.clone()
        case 2:
            obstacle = redObject.clone()
        default:
            obstacle = purpleObject.clone()
        }
        obstacle.position = vector
        nodeToAddTo.addChildNode(obstacle)
        moveObjectPastCamera(obstacle)
    }
    
    func moveObjectPastCamera(node: SCNNode){
        node.runAction(moveAction)
    }
    
}
