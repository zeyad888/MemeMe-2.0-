//
//  ImageViewController.swift
//  MemeMe 2.0
//
//  Created by Zeyad AlHusainan on 16/02/2019.
//  Copyright © 2019 Zeyad. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    // MARK: Properties
    
    var meme: Meme!

    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.imageView?.image = UIImage(cgImage: meme.memedImage as! CGImage)
    }
    

}
