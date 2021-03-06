//
//  ViewController.swift
//  BPM-X-Ray
//
//  Created by pc on 11/12/15.
//  Copyright © 2015 Bizagi. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    enum Menu{
        case shapes
        case lines
        case text
    }
    
    
    
    var pallete: ColorPallete?
    
    @IBOutlet var spinner:UIActivityIndicatorView!
    @IBOutlet var imageView:UIImageView?
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet weak var sideMenu: UIView!
    @IBOutlet weak var topMenuView: UIView!
    
    @IBOutlet weak var shapesButton: UIView!
    @IBOutlet weak var shapesSubMenu: UIStackView!
    @IBOutlet weak var taskOpt: UIView!
    @IBOutlet weak var startOpt: UIView!
    @IBOutlet weak var stopOpt: UIView!
    @IBOutlet weak var conditionalOpt: UIView!
    
    
    
    @IBOutlet weak var linesButton: UIView!
    @IBOutlet weak var linesSubMenu: UIStackView!
    
    
    @IBOutlet weak var textButton: UIView!
    
    var selectedImage: UIImage?
    var imagePicker: UIImagePickerController!
    
    
//    @IBOutlet weak var shapesLabel: UILabel!
    @IBOutlet weak var linesLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    var editView: UIView?
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        ColorPallete *pallete = [ColorPallete sharedManager];
        pallete = ColorPallete.sharedManager() as? ColorPallete
//        UIView* rect = [[UIView alloc] initWithFrame:CGRectMake(r.x, r.y, r.width, r.height) ];
//        [rect setBackgroundColor:pallete.lightGreen];
        
        topMenuView.backgroundColor = pallete?.backGround
        sideMenu.backgroundColor = pallete?.sideBackGroundLight
        shapesButton.backgroundColor = pallete?.sideBackGround
        linesButton.backgroundColor = pallete?.sideBackGround
        textButton.backgroundColor = pallete?.sideBackGround
        
//        textLabel.textColor = pallete?.textSideBar
//        linesLabel.textColor = pallete?.textSideBar
//        shapesLabel.textColor = pallete?.textSideBar
        
        
        scrollView.backgroundColor = UIColor.grayColor()
//        shapesButton.backgroundColor = UIColor.blueColor()
//        shapesButton.layer.borderColor = UIColor.blueColor().CGColor
        
        shapesButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "displayShapesSubMenu"))
        linesButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "displayLinesSubMenu"))
        
        taskOpt.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "changeToTask"))
        startOpt.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "changeToStart"))
        stopOpt.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "changeToStop"))
        conditionalOpt.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "changeToConditional"))
        
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideSideMenu"))
        scrollView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "addElement:"))
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //        stitch()
//        selectedImage = UIImage(named:"foto1")
//                detect()
    }
    
    @IBAction func takePicture(sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        imagePicker.allowsEditing = true
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func photoLibrary(sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.allowsEditing = true
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        
        if picker.sourceType == .Camera{
            UIImageWriteToSavedPhotosAlbum(selectedImage!, self, "image:didFinishSavingWithError:contextInfo:", nil)
        }
        detect()
        
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
//        if error == nil {
//            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(ac, animated: true, completion: nil)
//        } else {
//            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(ac, animated: true, completion: nil)
//        }
    }
    
    
    @IBAction func toogleSideMenu(sender: AnyObject) {
        if sideMenu.hidden{
            sideMenu.hidden = false
        }else{
            sideMenu.hidden = true
        }
        
    }
    
    
    
//    func viewForZoomingInScrollView(scrollView:UIScrollView) -> UIView? {
//        return self.imageView!
//    }
    
    func detect() {
        self.spinner.startAnimating()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let image = self.selectedImage
            
//                        let image = UIImage(named:"foto1")
            
            //            let image = UIImage(named:"bpm")
            //let image = UIImage(named:"circle")
            //let image = UIImage(named:"FullSizeRender-1")
            //let image = UIImage(named: "FullSizeRender")
            
            var detectedImageArray:NSArray?
            
            for index in 1...10{
                let scaleT = CGFloat(index) / CGFloat(10.0)
                let size = CGSizeApplyAffineTransform(image!.size, CGAffineTransformMakeScale(scaleT, scaleT))
                let hasAlpha = false
                let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
                
                UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
                image!.drawInRect(CGRect(origin: CGPointZero, size: size))
                
                let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                let detectedImageArrayTemp:NSArray = CVWrapper.detectBPM(scaledImage) as NSArray
                
                if detectedImageArray != nil || detectedImageArrayTemp.count > detectedImageArray?.count{
                    detectedImageArray = detectedImageArrayTemp
                }
                
            }
            
            
            
            
            let detectedImage:UIImage = detectedImageArray!.lastObject as! UIImage
            
            dispatch_async(dispatch_get_main_queue()) {
                for view in self.scrollView.subviews {
                    view.removeFromSuperview()
                }
                
                let imageView:UIImageView = UIImageView(image: detectedImage)
                imageView.alpha = 0.2
                self.imageView = imageView
                self.scrollView.addSubview(self.imageView!)
                self.scrollView.contentSize = self.imageView!.bounds.size
                self.scrollView.maximumZoomScale = 4.0
                self.scrollView.minimumZoomScale = 0.5
                self.scrollView.delegate = self
//                self.scrollView.contentOffset = CGPoint(x: -(self.scrollView.bounds.size.width - self.imageView!.bounds.size.width)/2.0, y: -(self.scrollView.bounds.size.height - self.imageView!.bounds.size.height)/2.0)
                NSLog("scrollview \(self.scrollView.contentSize)")
                
                for index in 0...(detectedImageArray!.count-1){
                    if( detectedImageArray![index].isKindOfClass(UIView) ){
                        print(detectedImageArray![index].frame)
                        let detectedImageView = detectedImageArray![index] as! UIView
                        detectedImageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "editItem:"))
                        self.scrollView.addSubview(detectedImageView)
                    }
                }
                
                

                
                
                self.spinner.stopAnimating()
                
            }
        }
    }
    
    func editItem(sender:UILongPressGestureRecognizer){
        print("edit me pls")
        sideMenu.hidden = false
        editView = sender.view

        self.scrollView.contentOffset = CGPoint(x: (editView?.frame.origin.x)! - 30 , y: (editView?.frame.origin.y)! - (self.scrollView.bounds.size.height/2 ) + 30)
    }

    
    func displayLinesSubMenu(){
        displaySubMenu(Menu.lines)
    }
    
    func displayShapesSubMenu(){
        displaySubMenu(Menu.shapes)
    }
    
    func displaySubMenu(menu: Menu){
        switch menu {
        case .shapes:
            if(shapesSubMenu.hidden){
                shapesSubMenu.hidden = false
            }else{
                shapesSubMenu.hidden = true
            }
            break
            
        case .lines:
            if(linesSubMenu.hidden){
                linesSubMenu.hidden = false
            }else{
                linesSubMenu.hidden = true
            }
            break
            
        default:
            break
        }
    }
    
    
    func changeToTask(){
        editView?.backgroundColor = pallete?.lightBlue
        editView?.layer.borderColor = pallete?.darkBlue.CGColor
        editView?.layer.cornerRadius = 5
        editView!.layer.borderWidth = 4
        
    }
    
    func changeToStart(){
        editView?.backgroundColor = pallete?.lightGreen
        editView?.layer.borderColor = pallete?.darkGreen.CGColor
        editView?.layer.cornerRadius = editView!.frame.size.width/2;
        editView!.layer.borderWidth = 4
    }
    
    func changeToStop(){
        editView?.backgroundColor = pallete?.lightRed
        editView?.layer.borderColor = pallete?.darkRed.CGColor
        editView?.layer.cornerRadius = editView!.frame.size.width/2;
        editView!.layer.borderWidth = 4
    }
    
    func changeToConditional(){
        editView?.backgroundColor = pallete?.lightYellow
        editView?.layer.borderColor = pallete?.darkYellow.CGColor
        editView?.layer.cornerRadius = 5
        editView!.layer.borderWidth = 4
        editView?.frame.size.width = (editView?.frame.size.height)!
        editView?.transform = CGAffineTransformMakeRotation(45)
    }
    
    func hideSideMenu(){
        sideMenu.hidden = true
    }
    
    func addElement(sender:UILongPressGestureRecognizer){
        let x = sender.locationInView(scrollView).x
        let y = sender.locationInView(scrollView).y
        sideMenu.hidden = false
        let frame = CGRectMake(x-25, y-25, 50, 50)
        let newView = UIView(frame: frame)

        newView.layer.cornerRadius = 5;
        scrollView.addSubview(newView)
        
        
        
        editView = newView

    }
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        sideMenu.hidden = true
//    }
    
}


