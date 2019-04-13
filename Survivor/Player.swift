//
//  Player.swift
// 
//
//  Created by Emmanuel Nativel on 3/23/19.
//  Copyright © 2019 Emmanuel Nativel. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    
    var direction:String = "RIGHT"
    var isAlive:Bool = true
    var isShooting:Bool = false
    var nbBulletsFired:Int = 0
    var gameOver = false
    
    func setupCollision(){
        //Paramètres pour gérer les collisions
        self.physicsBody?.categoryBitMask = playerCategory
        self.physicsBody?.collisionBitMask = groundCategory
        self.physicsBody?.contactTestBitMask = 0
    }
    
    func setupBody(){
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: self.direction+"_1_IDLE_000") , size:self.size)
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = true
    }
    
    func attack(direction:String, sens:CGFloat){
            if(self.isAlive && !self.isShooting){
                self.isShooting = true
                self.direction = direction
                
                self.removeAllActions()
                
                let attackAnimation:SKAction = SKAction(named: "Attack_"+self.direction)!
                
                //Lorsque l'animation d'attaque est terminée
                let finish:SKAction = SKAction.run {
                    //Mise à jour de l'orientation du personnage
                    let idle:SKAction = SKAction(named: "Idle_"+self.direction)!
                    //Mise à jour de la hitBox du personnage
                    self.setupBody()
                    
                    self.run(idle)
                    
                    //Lancement du projectile
                    let bullet:Projectile = Projectile(scene: self.scene!, player: self, xpos: self.position.x * sens, ypos: self.position.y)
                    bullet.move(sens: sens, animation: "BulletMove_"+self.direction)
                    self.nbBulletsFired += 1
                    
                    self.setupCollision()
                    self.isShooting = false
                }
                
                let seq:SKAction = SKAction.sequence([attackAnimation, finish])
                self.run(seq)
        }
    }
    
    func die(){
        isAlive = false
        self.removeAllActions()

        let die:SKAction = SKAction(named: self.direction+"_DiePlayer")!
        let finish:SKAction = SKAction.run {
            self.removeFromParent()
            self.gameOver = true
        }
        let seq:SKAction = SKAction.sequence([die, finish])
        self.run(seq)
    }
    
    
}
