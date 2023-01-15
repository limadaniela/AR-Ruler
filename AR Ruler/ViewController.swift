//
//  ViewController.swift
//  AR Ruler
//
//  Created by D L on 2023-01-14.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    //to keep track of all the dotNodes that we put onto de scene
    var dotNodes = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        configuration.planeDetection = .horizontal
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //tells object that new touches occurred in a view or window
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //to detect tpuch location
        guard let touchLocation = touches.first?.location(in: sceneView) else {return}
        //to convert touch location into 3D location inside our scene
        guard let query = sceneView.raycastQuery(from: touchLocation, allowing: .existingPlaneGeometry, alignment: .any) else {return}
        
        let hitTestResults = sceneView.session.raycast(query)
        
        if let hitResult = hitTestResults.first {
            addDot(at: hitResult)
        }
    }
    //to add a node into de 3D word and show where we tapped
    func addDot(at hitResult : ARRaycastResult) {
        let dotGeometry = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        //to specify a position of dotNode in 3D
        dotNode.position = SCNVector3(
            x: hitResult.worldTransform.columns.3.x,
            y: hitResult.worldTransform.columns.3.y,
            z: hitResult.worldTransform.columns.3.z
        )
        
        //to add dotNode into scene
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodes.append(dotNode)
        if dotNodes.count >= 2 {
            calculate()
        }
    }
    
    func calculate () {
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        let distance = sqrt(
            pow(end.position.x - start.position.x, 2) +
            pow(end.position.y - start.position.y, 2) +
            pow(end.position.z - start.position.z, 2)
        )
        print(distance)
    }
}


