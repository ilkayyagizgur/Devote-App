//
//  DevoteWidgetBundle.swift
//  DevoteWidget
//
//  Created by Ada Yagiz Gur on 18.03.2023.
//

import WidgetKit
import SwiftUI

@main
struct DevoteWidgetBundle: WidgetBundle {
    var body: some Widget {
        DevoteWidget()
        DevoteWidgetLiveActivity()
    }
}
