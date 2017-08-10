//
//  Task.swift
//  taskapp
//
//  Created by 池内佳史 on 2017/07/31.
//  Copyright © 2017年 池内佳史. All rights reserved.
//

import RealmSwift

class Task: Object {
    // 管理用の ID。プライマリーキー
    dynamic var id = 0
    
    // タイトル
    dynamic var title = ""
    
    // 内容
    dynamic var contents = ""
    
    /// 日時
    dynamic var date = NSDate()
    
    // category
    dynamic var category = ""
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
    return "id"
    }
}

