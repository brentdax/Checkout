//
//  RepresentationTabController.swift
//  Checkout Viewer
//
//  Created by Brent Royal-Gordon on 11/6/17.
//  Copyright © 2017 Architechies. All rights reserved.
//

import AppKit

protocol RepresentationViewController: class {
    var desiredRepresentationKeyPath: PartialKeyPath<ReceiptRepresentations> { get }
    var representedObject: Any? { get set }
}

class RepresentationsTabViewController: NSTabViewController {
    override var representedObject: Any? {
        didSet {
            guard let representations = representedObject as? ReceiptRepresentations? else {
                preconditionFailure("RepresentationTabController.representedObject set to \(String(describing: representedObject)), which is not an Optional<ReceiptRepresentations>")
            }
            
            for item in tabViewItems {
                guard let controller = item.viewController as? RepresentationViewController else {
                    preconditionFailure("Tab bar item is not a RepresentationViewController")
                }
                
                controller.representedObject = representations[keyPath: controller.desiredRepresentationKeyPath]
            }
        }
    }
    
    func wrapViewControllerIfNeeded(in tabViewItem: NSTabViewItem) {
        if tabViewItem.viewController is FallibleViewController {
            return
        }
        
        let fallibleController = storyboard!.instantiateController(withIdentifier: .fallibleViewController) as! FallibleViewController
        fallibleController.successViewController = tabViewItem.viewController as! (NSViewController & RepresentationViewController)?
        
        tabViewItem.viewController = fallibleController
    }
    
    override func addTabViewItem(_ tabViewItem: NSTabViewItem) {
        wrapViewControllerIfNeeded(in: tabViewItem)
        super.addTabViewItem(tabViewItem)
    }
}
