//
//  PlaneScene.swift
//  Plane
//
//  Created by Francesca Cuda on 30/12/2017.
//  Copyright © 2017 Francesca Cuda. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class PlaneScene: SCNScene, SCNSceneRendererDelegate {
    
    let planeAttach = SCNNode()
    var timeLast: Double?
    let speedConstant = 1.5
    var planeLocationRotation:Double = 0.0
    
    let obstacles = Obstacles()
    
    convenience init(create: Bool) {
        self.init()
        
        setupCameraLightsAndExtras()
        
        let planeScene = SCNScene(named: "art.scnassets/SimplePlane.dae")!
        let plane = planeScene.rootNode.childNode(withName: "Plane", recursively: true)!
        let propeller = planeScene.rootNode.childNode(withName: "Propeller", recursively: true)!
        
        plane.name = "Plane"
        propeller.name = "Propeller"
        planeAttach.name = "Empty"
        
        planeAttach.addChildNode(plane)
        planeAttach.addChildNode(propeller)
        
        rootNode.addChildNode(planeAttach)
        
        // add action
        let rotationAction = SCNAction.rotate(by: .pi, around: SCNVector3(0,0,1), duration: 0.3)
        let rotateForever = SCNAction.repeatForever(rotationAction)
        propeller.runAction(rotateForever)
        
        obstacles.spawnObstacles(self.rootNode)
        
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        var dt:Double
        if let lt = timeLast {
            dt = time - lt
        } else {
            dt=0
        }
        timeLast = time
        
        planeLocationRotation+=(dt * speedConstant)
        //gentle wave - sin
        let yPosition = (sin(planeLocationRotation)/4.0)
        let planeRotation = (cos(planeLocationRotation)/4.0)
        
        planeAttach.position = SCNVector3(0, Float(yPosition), 0)
        planeAttach.rotation = SCNVector4(1, 0, 0, Float(planeRotation))
        
        if planeLocationRotation > Double.pi * 2 {
            planeLocationRotation -= (Double.pi * 2)
        }
    }
    
    func setupCameraLightsAndExtras() {
        
        //CAMERA AND LIGHTS
        ///////////////////
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.usesOrthographicProjection = false
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -5)
        
        let lightNodeSpot = SCNNode()
        lightNodeSpot.light = SCNLight()
        lightNodeSpot.light!.type = SCNLight.LightType.spot
        lightNodeSpot.position = SCNVector3(x: 30, y: 30, z: 30)
        
        let empty = SCNNode()
        empty.position = SCNVector3Zero
        
        lightNodeSpot.constraints = [SCNLookAtConstraint(target: empty)]
        
        rootNode.addChildNode(empty)
        rootNode.addChildNode(cameraNode)
        rootNode.addChildNode(lightNodeSpot)
        
        //EXTRA NODES
        /////////////
        
        let clouds = SCNParticleSystem(named: "Clouds.scnp", inDirectory: "")!
        let cloudsEmitter = SCNNode()
        cloudsEmitter.position = SCNVector3(x: 0, y: -4, z: -3)
        cloudsEmitter.addParticleSystem(clouds)
        
        rootNode.addChildNode(cloudsEmitter)
        
    }
    
}
