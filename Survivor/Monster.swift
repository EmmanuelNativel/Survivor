//
//  Golem.swift
//  test
//
//  Created by Emmanuel Nativel on 3/24/19.
//  Copyright © 2019 Emmanuel Nativel. All rights reserved.
//

import Foundation
import SpriteKit

class Monster:SKSpriteNode {
    
    var valeur:Int = 0
    var pv:Int = 0
    var vitesse:TimeInterval = 0
    var direction:String = "RIGHT"
    var sens:CGFloat = 1
    var type:String = ""
    var source:MonsterGenerator!
    var gameScene:GameScene!
    
    var isHurted:Bool = false
    
    init(scene:SKScene, source:MonsterGenerator, vie:Int, directionMove:String, monsterType:String) {
        let texture = SKTexture(imageNamed: "\(directionMove)_\(monsterType)_Walking_000")
        let color = UIColor.black
        let size = CGSize(width: 80, height: 80)
        super.init(texture: texture, color: color, size: size)
        
        self.name = "monster"
        self.type = monsterType
        self.pv = vie
        self.valeur = vie
        self.direction = directionMove
        self.sens = self.direction == "RIGHT" ? 1 : -1
        self.position = CGPoint(x: -sens*scene.size.width/2, y: -50)
        self.vitesse = 6
        self.source = source
        self.gameScene = scene as! GameScene
        
        //Création et paramétrage du corp physique des monstres
        self.physicsBody = SKPhysicsBody(texture: texture, size:CGSize(width: 80, height: 80))
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = true
        
        scene.addChild(self)
        
        //Paramètres pour gérer les collisions
        self.physicsBody?.categoryBitMask = monsterCategory
        self.physicsBody?.collisionBitMask = groundCategory
        self.physicsBody?.contactTestBitMask = projectileCategory | playerCategory  //On test quand le monstre entre en collision avec un projectile ou le joueur
        
        self.move()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(){
        let moveAnimation:SKAction = SKAction(named: direction+"_Move"+type)!
        let moveAction:SKAction = SKAction.moveTo(x: 0, duration: vitesse)
        let group:SKAction = SKAction.group([moveAnimation, moveAction])
        self.run(group)
    }
    
    func desableCollisionsWithObject(category:UInt32){
        self.physicsBody?.contactTestBitMask &= ~category
    }
    
    func die(){
        self.removeAllActions()
        desableCollisionsWithObject(category:projectileCategory)
        let updateScore:SKAction = SKAction.run {
            self.gameScene.score += self.valeur
        }
        let dieAnimation:SKAction = SKAction(named: direction+"_Die"+type)!
        let finish:SKAction = SKAction.run {
            self.removeFromParent()
            self.source.removeMonster(monster: self)
        }
        let seq:SKAction = SKAction.sequence([updateScore, dieAnimation, finish])
        self.run(seq)
    }
    
    func beHurted(){
        if(!isHurted){ //Si le monstre n'est pas déjà entrain d'être blessé
            isHurted = true
            self.pv -= 1
            let hurt:SKAction = SKAction.colorize(with: self.pv>1 ? UIColor.orange:UIColor.red, colorBlendFactor: 1, duration: 0.1) //Changement de couleur en fonction des pv restants
            let wait:SKAction = SKAction.wait(forDuration: 0.2) //Delay pour éviter d'être blesser plusieurs fois lors d'un seul contact entre le projectile et le monstre
            let finish:SKAction = SKAction.run {
                self.isHurted = false
            }
            let seq:SKAction = SKAction.sequence([hurt, wait, finish])
            self.run(seq)
        }
    }
    
    func attack(){
        self.removeAllActions()
        let attackAnimation:SKAction = SKAction(named: direction+"_Attack"+type)!
        let wait:SKAction = SKAction.wait(forDuration: 1)
        let finish:SKAction = SKAction.run {
            self.removeFromParent()
        }
        let seq:SKAction = SKAction.sequence([attackAnimation, wait, finish])
        self.run(seq)
    }

    
}
