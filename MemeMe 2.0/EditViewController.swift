//
//  EditViewController.swift
//  MemeMe 2.0
//
//  Created by Zeyad AlHusainan on 12/02/2019.
//  Copyright © 2019 Zeyad. All rights reserved.
//

import UIKit


class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var navbar: UIToolbar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setTextAttribut(textField: topTextField, str: " TOP ")
        setTextAttribut(textField: bottomTextField, str: " BOTTOM ")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        // Enable the camera button when it is available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    //Func to pick image from Album
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        
        pickAnImage(source: .photoLibrary)
    }
    
    //Func to pick image from camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        pickAnImage(source: .camera)
    }
    
    //Func for picking An Image
    func pickAnImage(source: UIImagePickerController.SourceType){
    
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
        
    }
        
    //Func to pass the selected image to imagePickerView
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
        
    //Func to cancel selection
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //Text Attributes
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -3.0
    ]
    
    //Set text fields attributs
    func setTextAttribut(textField : UITextField, str : String) {
        
        textField.delegate = self
        textField.text = str
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    //Erase " TOP " & " BOTTOM "
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        if (textField == topTextField && topTextField.text == " TOP ") {
            topTextField.text = ""
        } else if (textField == bottomTextField && bottomTextField.text == " BOTTOM ") {
            bottomTextField.text = ""
        }
    }
    
    //Keyboard
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    func save() {

        let memedImage = generateMemedImage()
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
   
    func generateMemedImage() -> UIImage {
        
        toolbar.isHidden = true
        navbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolbar.isHidden = false
        navbar.isHidden = false
        
        return memedImage
    }
    
    @IBAction func share(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                //Save the image
                self.save()
                //Dismiss the view controller
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(activityViewController, animated: true, completion: nil)
        
    }
}

