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
    
    var nbMonstersMax:Int = 3
    var generationIsAllowed = true
    var limite:CGFloat = 0
    
    init(scene:SKScene, direction:String) {
        self.scene = scene
        self.direction = direction
        self.sens = direction == "RIGHT" ? 1 : -1
        self.limite = (self.scene.size.width/2) - CGFloat(Int.random(in: 30 ... 150)) //Lorsque le dernier monstre dépasse cette limite aléatoire, un nouveau monstre pourra être généré.
    }
    
    func chooseMonster() -> (String,Int){
        //tirer un nombre aléatoire
        let type:String
        let pv:Int
        let nbAlea:Int = Int.random(in: 0 ... 10)
        switch nbAlea {
        case 1 :
            type = "Knight"
            pv = 3
        case 2,3,4:
            type = "Golem"
            pv = 2
        default:
            type = "Gobelin"
            pv = 1
        }
        
        return (type, pv)
    }
    
    func generate(){
        let monster = self.chooseMonster() //renvoi un couple (typeMonster, PvMonster)
        if(monsters.count == 0) {
            self.monsters.append(Monster(scene: self.scene, source:self, vie: monster.1, directionMove: self.direction, monsterType: monster.0))
        } else if(monsters.count >= nbMonstersMax || (monsters.last!.position.x < -self.limite && self.sens == 1) || (monsters.last!.position.x > self.limite && self.sens == -1) ){
            self.generationIsAllowed = false
        } else {
            self.generationIsAllowed = true
        }
        
        if(generationIsAllowed) {
            self.monsters.append(Monster(scene: self.scene, source:self, vie: monster.1, directionMove: self.direction, monsterType: monster.0))
        }
    }
    
    func removeMonster(monster:Monster){
        if let index = self.monsters.index(of:monster) {
            self.monsters.remove(at:index)
        }
    }
    
}
