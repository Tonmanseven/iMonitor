//
//  Models.swift
//  iMonitor
//
//  Created by Булат Сунгатуллин on 19/09/2019.
//  Copyright © 2019 Булат Сунгатуллин. All rights reserved.
//

import Foundation


class Posts {
    
    let iesk_controllers = ["wirenboard-AXGDGLNQ", "wirenboard-AD7R5B2", "wirenboard-AGGQ4OWDbv  "]
    let iesk_posts = ["Пост№1 Опора П 203/56 кВ", "Пост№2 Опора П 203/60 кВ", "Пост№3 Опора КРУЭ Б 220 кВ"]
    
    let mrsk_controllers = ["wirenboard-ARC3DJ3L", "wirenboard-AB3A6J7Q", "wirenboard-ADOVDGMJ"]
    let mrsk_posts = ["Пост№1 Опора 108", "Пост№2 Опора 31", "Пост№3 Опора 247"]
    
    func checkProject(row: Int) -> [String]{
        if row == 0 {
            return iesk_posts
        } else {
            return mrsk_posts
        }
    }
    
    func getPostName(projName: Int, row: Int) -> String {
        if projName == 0{
            //iesk
            return iesk_controllers[row]
        } else {
            //mrsk
            return mrsk_controllers[row]
        }
    }
    
}
