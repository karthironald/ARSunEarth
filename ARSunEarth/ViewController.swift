//
//  ViewController.swift
//  ARSunEarth
//
//  Created by Karthick Selvaraj on 16/09/17.
//  Copyright © 2017 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var sunAdded = false
    var earthAdded = false
    
    
    // MARK: - View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    // MARK: - To create sun and earth
    
    /**Create sun and earth node*/
    func create(at position: SCNVector3) -> SCNNode? {
        if sunAdded == false {
            let sphere = SCNSphere(radius: 0.15)
            let matrial = SCNMaterial()
            matrial.diffuse.contents = UIImage(named: "art.scnassets/sun.jpg")
            sphere.firstMaterial = matrial
            let node = SCNNode(geometry: sphere)
            node.position = position
            sunAdded = true
            return node
        } else if earthAdded == false {
            let sphere = SCNSphere(radius: 0.15)
            let matrial = SCNMaterial()
            matrial.diffuse.contents = UIImage(named: "art.scnassets/earth.jpg")
            sphere.firstMaterial = matrial
            let node = SCNNode(geometry: sphere)
            node.position = position
            earthAdded = true
            rotateMyBall(node: node)
            return node
        }
        return nil
    }
    
    /**Listen for touch action*/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // To create sun and earth at when user taps on screen.
        guard let touch = touches.first else { return }
        let result = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
        guard let hitresult = result.first else { return }
        let tranform = hitresult.worldTransform
        let transform = SCNMatrix4.init(tranform)
        let hitVector = SCNVector3Make(transform.m41, transform.m42, transform.m43)
        if let node = create(at: hitVector) {
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    /**Rotate given ball*/
    func rotateMyBall(node: SCNNode) {
        let rotateAction = SCNAction.rotate(by: 1.571 , around: SCNVector3Make(0, 1, 0), duration: 1)
        node.runAction(rotateAction, completionHandler: {self.rotateMyBall(node: node)})
    }

}
