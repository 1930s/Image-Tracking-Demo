//
//  ViewController.swift
//  Image-Tracking-Demo
//
//  Created by William Jones on 10/2/18.
//  Copyright © 2018 William Jones. All rights reserved.
//
// Planet textues:
//              https://www.solarsystemscope.com/textures
// 3D Models:
//              http://turbosquid.com
//              http://roestudios.co.uk
// AR Projects:
//              https://github.com/olucurious/Awesome-ARKit
//              https://twitter.com/madewithARKit
// Sample USDZ files:
//              https://developer.apple.com/arkit/gallery/
// Convert OBJ->USDZ: xcrun usdz_converter {path/fromName} {path/toName}

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Add other 3D models
        addDice()
        addCube()
        addSphere()
        addPlane()
        helloARKit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        // let configuration = ARWorldTrackingConfiguration()
        
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "PlayingCards", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 2
            print("images added...")
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func addDice() {
        let dice = SCNScene(named: "art.scnassets/diceCollada.scn")!
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "New_RedBase_Color.png")
        if let diceNode = dice.rootNode.childNode(withName: "Dice", recursively: true) {
            diceNode.position = SCNVector3(-0.1, 0.1, -0.1)
            sceneView.scene.rootNode.addChildNode(diceNode)
        }
    }
    
    func addCube() {
        // add box
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.orange
        cube.materials = [material]
        let node = SCNNode()
        node.name = "Orange Cube"
        node.position = SCNVector3(x: -0.2, y: 0.1, z: -0.5)
        node.geometry = cube
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func addSphere() {
        // add sphere
        let sphere = SCNSphere(radius: 0.2)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/moon.jpg")
        sphere.materials = [material]
        let node = SCNNode()
        node.name = "Moon"
        node.position = SCNVector3(0.6, 0.1, -2.0)
        node.geometry = sphere
        sceneView.scene.rootNode.addChildNode(node)
        let action = SCNAction.rotateBy(x: 0.1, y: 0.6, z: 0, duration: 1)
        let repAction = SCNAction.repeatForever(action)
        node.runAction(repAction)
    }
    
    func addPlane() {
        // add sphere
        let plane = SCNPlane(width: 1.0, height: 1.0)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/MonaLisa.jpg")
        plane.materials = [material]
        let node = SCNNode()
        node.name = "Mona Lisa"
        node.position = SCNVector3(-0.6, 0.1, -2.0)
        node.geometry = plane
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func helloARKit() {
        let textGeometry = SCNText(string: "Hello, ARKit!", extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        let textNode = SCNNode(geometry: textGeometry)
        textNode.name = "AR Text"
        textNode.position = SCNVector3(-0.5, -0.2, -0.9)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor {
            print("image detected: \(imageAnchor.referenceImage.name)")
            // add plane to detected imgage
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
            let planeNode = SCNNode(geometry: plane)
            // rotate the plane 90 degrees
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            
            // determine which image was detected
            if imageAnchor.referenceImage.name == "Ace" {
                let node = getMoonNode()
                planeNode.addChildNode(node)
            }
            
            if imageAnchor.referenceImage.name == "Joker" {
                let node = getMoonNode()
                planeNode.addChildNode(node)
            }
            
        }
        
        return node
    }
    
    func getMoonNode() -> SCNNode {
        // add sphere and material to sphere
        let sphere = SCNSphere(radius: 0.02)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/moon.jpg")
        sphere.materials = [material]
        let node = SCNNode()
        node.position = SCNVector3(0.0, 0.0, 0.03)
        node.geometry = sphere
        sceneView.scene.rootNode.addChildNode(node)
        
        // rotate the moon
        let action = SCNAction.rotateBy(x: 0.1, y: 0.6, z: 0, duration: 1)
        let repAction = SCNAction.repeatForever(action)
        node.runAction(repAction)
        
        return node
    }
    
}
