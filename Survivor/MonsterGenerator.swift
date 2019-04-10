//
//  MonsterGenerator.swift
//  test
//
//  Created by Emmanuel Nativel on 3/29/19.
//  Copyright © 2019 Emmanuel Nativel. All rights reserved.
//

import Foundation
import SpriteKit

class MonsterGenerator {
    var monsters:[Monster] = []
    var cible:CGPoint = CGPoint(x:0,y:0)
    var direction:String!
    var sens:CGFloat!
    var scene:SKScene!
    
    var nbMonstersMax:Int = 2
    var generationIsAllowed = false
    var limite:CGFloat = 0
    
    init(scene:SKScene, direction:String) {
        self.scene = scene
        self.direction = direction
        self.sens = direction == "RIGHT" ? 1 : -1
        self.limite = (self.scene.size.width/2) - CGFloat(Int.random(in: 30 ... 150)) //Lorsque le dernier monstre dépasse cette limite aléatoire, un nouveau monstre pourra être généré.
    }
    
    func chooseMonster() -> Monster{
        //tirer un nombre aléatoire
        let type:String
        let pv:Int
        let nbAlea:Int = Int.random(in: 0 ... 10)
        switch nbAlea {
        case 1,2,3 :
            type = "Knight"
            pv = 3
        case 4, 5, 6, 7:
            type = "Golem"
            pv = 2
        default:
            type = "Gobelin"
            pv = 1
        }
        
        return( Monster(scene: scene, source:self, vie: pv, directionMove: self.direction, monsterType: type) )
    }
    
    func generate(){
        if(monsters.count == 0) {
            let monster:Monster = self.chooseMonster()
            self.monsters.append(monster)
        } else if(monsters.count >= nbMonstersMax || (monsters.last!.position.x < -self.limite && self.sens == 1) || (monsters.last!.position.x > self.limite && self.sens == -1) ){
            self.generationIsAllowed = false
        } else {
            self.generationIsAllowed = true
        }
        
        if(generationIsAllowed) {
            let monster:Monster = self.chooseMonster()
            self.monsters.append(monster)
        }
    }
    
    func removeMonster(monster:Monster){
        if let index = self.monsters.index(of:monster) {
            self.monsters.remove(at:index)
        }
    }
    
}
