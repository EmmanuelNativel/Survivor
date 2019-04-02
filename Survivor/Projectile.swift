//
//  Projectile.swift
//  test
//
//  Created by Emmanuel Nativel on 3/23/19.
//  Copyright © 2019 Emmanuel Nativel. All rights reserved.
//

import Foundation
import SpriteKit

class Projectile:SKSpriteNode {
    
    var player:Player!  //A SUPPRIMER ????
    
    init(scene:SKScene, player:Player, xpos:CGFloat, ypos:CGFloat) {
        let texture = SKTexture(imageNamed: "RIGHT_BULLET_1")
        let color = UIColor.black
        let size = CGSize(width: 42, height: 30)
        super.init(texture: texture, color: color, size: size)
        
        self.name = "bullet"
        self.player = player
        self.position.x = xpos
        self.position.y = ypos
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size:self.size)
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = false
        
        scene.addChild(self)
        
        self.physicsBody?.categoryBitMask = projectileCategory
        self.physicsBody?.collisionBitMask = groundCategory
        self.physicsBody?.contactTestBitMask = 0 //C'est le monstre qui entre en collision avec le projectile, pour pouvoir désactiver la collision quand le monstre est mort.
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(sens:CGFloat, animation:String){
        //let wait:SKAction = SKAction.wait(forDuration: 0.5)
        let moveAnimation:SKAction = SKAction(named: animation)!
        let moveAction:SKAction = SKAction.moveTo(x: sens * (self.scene?.size.width)!, duration: 0.8)
        let group:SKAction = SKAction.group([moveAnimation, moveAction]) //Faire un groupe permet de faire les 2 actions en même temps.
        self.run(group)
    }
    
    //Supprimer le projectile
    func destroy(){
        /*
        if let index = self.player.projectiles.index(of:self) {
            self.player.projectiles.remove(at: index)
        }*/
        self.removeFromParent()
    }
}
