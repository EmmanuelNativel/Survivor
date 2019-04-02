//
//  GameScene.swift
//  test
//
//  Created by Emmanuel Nativel on 3/23/19.
//  Copyright © 2019 Emmanuel Nativel. All rights reserved.
//

import SpriteKit
import GameplayKit

let playerCategory:UInt32 = 1 << 0      // ...0000001
let monsterCategory:UInt32 = 1 << 1     // ...0000010
let projectileCategory:UInt32 = 1 << 2  // ...0000100
let groundCategory:UInt32 = 1 << 3       // ...0001000


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Faire disparaitre les monstres quand le joueur est tué
    //Revoir le resize de l'anim attack du perso ET mort du knight
    
    var player:Player!
    var generateurMonstreRight:MonsterGenerator!
    var generateurMonstreLeft:MonsterGenerator!
    var background:SKSpriteNode!
    var ground:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        if let node:Player = self.childNode(withName: "player") as? Player {
            player = node
            player.setupCollision()
        }
        
        if let back:SKSpriteNode = self.childNode(withName: "background") as? SKSpriteNode {
            background = back
            background.texture = SKTexture(imageNamed: "Background")
        }
        
        if let g:SKSpriteNode = self.childNode(withName: "ground") as? SKSpriteNode {
            ground = g
            //ground.texture = SKTexture(imageNamed: "ground")
            ground.physicsBody?.categoryBitMask = groundCategory
        }
        
        self.generateurMonstreRight = MonsterGenerator(scene: self, direction: "RIGHT")
        self.generateurMonstreLeft = MonsterGenerator(scene: self, direction: "LEFT")
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if(!player.gameOver){
            generateurMonstreRight.generate()
            generateurMonstreLeft.generate()
            deleteExtraNodes()
        } else {
            for node in self.children {
                if(node.name == "monster"){
                    node.removeFromParent()
                }
            }
        }
            
        }
    
    
    func deleteExtraNodes(){
        if let node:Projectile = self.childNode(withName: "bullet") as? Projectile {
            if(node.position.x > (self.size.width/2) || node.position.x < -(self.size.width/2)){
                node.destroy()
            }
        }
    }

    
    
    func touchDown(atPoint pos : CGPoint) {
        
        if(pos.x > 0){
            //right half touch
            player.attack(direction: "RIGHT", sens: 1)
        } else {
            //left half touch
            player.attack(direction: "LEFT", sens: -1)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
            break
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    // ========= Collisions
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // *** Collision Projectile - Monster
        
        if(contact.bodyA.categoryBitMask == projectileCategory  && contact.bodyB.categoryBitMask == monsterCategory ){
            
            let monster:Monster = contact.bodyB.node as! Monster
            monster.beHurted()
            if(monster.pv == 0){ monster.die() }
        
            let bullet:Projectile = contact.bodyA.node as! Projectile
            bullet.destroy()
        }
        
        if(contact.bodyB.categoryBitMask == projectileCategory && contact.bodyA.categoryBitMask == monsterCategory ){
            
            //print("contact")
            let monster:Monster = contact.bodyA.node as! Monster
            monster.beHurted()
            if(monster.pv == 0){ monster.die() }
            
            let bullet:Projectile = contact.bodyB.node as! Projectile
            bullet.destroy()
        }
        
        // *** Collision Player-Monster
        
        if(contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == monsterCategory){
            
            let monster:Monster = contact.bodyB.node as! Monster

            monster.attack()
            player.die()
        }
        /*
         if(contact.bodyB.categoryBitMask == playerCategory && contact.bodyA.categoryBitMask == monsterCategory ){
         
         let monster:Monster = contact.bodyA.node as! Monster
         monster.attack()
         player.die()
         }
         */
    }

}
