//
//  PMAlertView.swift
//  MyAlertView
//
//  Created by Pavan Manjani on 20/11/17.
//  Copyright © 2017 SN. All rights reserved.
//

import UIKit

protocol PMAlertViewDelegate
{
    func PMAVTapped(buttonIndex:Int)
}

extension PMAlertViewDelegate {
    
    func PMAVTapped(buttonIndex:Int) {
        //this is a empty implementation to allow this method to be optional
    }
}

class PMAlertView: UIView
{
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var PMView : PMAlertView!
    fileprivate var ViewLayer : UIView!
    fileprivate var objPMAlertViewType: PMAlertViewType!
    fileprivate var objPMAVDelgate: PMAlertViewDelegate?
    fileprivate let objWindow = UIApplication.shared.keyWindow!
    var arr = [UIView]()
    
    enum PMAlertViewType:String
    {
        case Done
        case Cancel
        case Ok
        case Confirm
        case Waiting
        case TxtFld
    }
    
    enum ButtonType:String
    {
        case Done
        case Cancel
        case Ok
        case Yes
        case No
    }
    
    enum TxtFldType:String
    {
        case Default
        case Secure
    }
    
    class var SharePMAV : PMAlertView
    {
        struct Static
        {
            static let instance = PMAlertView()
        }
        return Static.instance
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        super.layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func ShowPMA(title:String?, msg:String?, type:PMAlertViewType, PVDelegate:Any?)
    {
        loadViewFromNib ()
        objPMAlertViewType = type
        addLbl(typeTitle: true, msg: title)
        addLbl(typeTitle: false, msg: msg)
        setValueForType()
        PMView.imgView.layer.cornerRadius = PMView.imgView.frame.size.width / 2
        objPMAVDelgate = nil
        if (PVDelegate != nil)
        {
            objPMAVDelgate = PVDelegate as? PMAlertViewDelegate
        }
        ShowImage(showImg: true)
        calulateSize()
        PMView.collectionView.reloadData()
        PMView.collectionView.layoutIfNeeded()
        calulateSize()
    }
    
    func ShowPMAWithSingleTextFld(title:String?, msg:String?,placeHolderTxt:String?, PVDelegate:Any?)
    {
        loadViewFromNib ()
        objPMAlertViewType = .TxtFld
        addLbl(typeTitle: true, msg: title)
        addLbl(typeTitle: false, msg: msg)
        addTxtFld(placeholder: placeHolderTxt, txtFldType: .Default, delegate: PVDelegate, keyBrdReturnType: .done)
        setValueForType()
        objPMAVDelgate = nil
        if (PVDelegate != nil)
        {
            objPMAVDelgate = PVDelegate as? PMAlertViewDelegate
        }
        ShowImage(showImg: false)
        calulateSize()
        PMView.collectionView.reloadData()
        PMView.collectionView.layoutIfNeeded()
        calulateSize()
    }
    
    func ShowPMAWithEmailAndPassTextFld(title:String?, msg:String?,placeHolderTxt1:String?,placeHolderTxt2:String?, PVDelegate:Any?)
    {
        loadViewFromNib ()
        objPMAlertViewType = .TxtFld
        addLbl(typeTitle: true, msg: title)
        addLbl(typeTitle: false, msg: msg)
        addTxtFld(placeholder: placeHolderTxt1, txtFldType: .Default, delegate: PVDelegate, keyBrdReturnType: .next)
        addTxtFld(placeholder: placeHolderTxt2, txtFldType: .Secure, delegate: PVDelegate, keyBrdReturnType: .done)
        setValueForType()
        objPMAVDelgate = nil
        if (PVDelegate != nil)
        {
            objPMAVDelgate = PVDelegate as? PMAlertViewDelegate
        }
        ShowImage(showImg: false)
        calulateSize()
        PMView.collectionView.reloadData()
        PMView.collectionView.layoutIfNeeded()
        calulateSize()
    }
    
    func hidePM()
    {
        showHideViewAnimation(isToShow: false)
    }
    
    func ShowImage(showImg:Bool)
    {
        PMView.imgView.isHidden = !showImg
        if showImg
        {}
        else
        {
            let filteredConstraints = PMView.imgView.constraints.filter { $0.identifier == "imgHgt"}
            if let hgtConstraint = filteredConstraints.first
            {
                hgtConstraint.constant = 5
                PMView.updateConstraintsIfNeeded()
                PMView.layoutIfNeeded()
                calulateSize()
            }
        }
        
        
    }
    
    fileprivate func loadViewFromNib()
    {
       ViewLayer = UIView(frame: CGRect(x: objWindow.frame.origin.x, y: objWindow.frame.origin.y, width: objWindow.frame.width, height: objWindow.frame.height))
        objWindow.addSubview(ViewLayer)
        ViewLayer.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.4)
        PMView = Bundle.main.loadNibNamed("PMAlertView", owner: nil, options: nil)![0] as! PMAlertView
        objWindow.addSubview(PMView)
        let nib = UINib(nibName: "CollectionViewCell", bundle:nil)
        PMView.collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        showHideViewAnimation(isToShow: true)
    }
    
    fileprivate func showHideViewAnimation(isToShow:Bool)
    {
        if isToShow
        {
            PMView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
                self.PMView.transform = CGAffineTransform.identity//CGAffineTransformIdentity
            }, completion: {(finished: Bool) -> Void in
            })
        }
        else
        {
            PMView.transform = CGAffineTransform.identity
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
                self.PMView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: {(finished: Bool) -> Void in
                self.ViewLayer.removeFromSuperview()
                self.PMView.removeFromSuperview()
            })
        }
    }
    
    
    
    
    fileprivate func addLbl(typeTitle:Bool, msg:String?)
    {
        guard (msg != nil) else {
            return
        }
        let msgLbl = UILabel()
        msgLbl.text = msg
        let obj = labelTagAndTitle(typeTitle: typeTitle)
        msgLbl.numberOfLines = obj.numberLines
        msgLbl.font = UIFont.systemFont(ofSize: obj.fontSize)
        msgLbl.textAlignment = .center
        msgLbl.lineBreakMode = .byWordWrapping
        msgLbl.sizeToFit()
        
        PMView.arr.append(msgLbl)
    }
    
    fileprivate func addTxtFld(placeholder:String?, txtFldType:TxtFldType, delegate:Any?, keyBrdReturnType : UIReturnKeyType)
    {
        let txtFld = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        txtFld.placeholder = placeholder
        txtFld.layer.masksToBounds = true
        txtFld.layer.borderColor = UIColor.black.cgColor
        txtFld.layer.borderWidth = 1.0
        txtFld.borderStyle = .bezel
        txtFld.autocorrectionType = .no
        txtFld.returnKeyType = keyBrdReturnType
        txtFld.tag = self.txtFldType(txtFldType: txtFldType).txtFldTag
        txtFld.isSecureTextEntry = self.txtFldType(txtFldType: txtFldType).IsSecureTxtFld
        txtFld.keyboardType = self.txtFldType(txtFldType: txtFldType).KeybrdType
        txtFld.addTarget(self, action: #selector(KeyboardDoneTapped(_:)), for: .editingDidEndOnExit)
        txtFld.heightAnchor.constraint(equalToConstant: 30).isActive = true
        if delegate is ViewController
        {
            txtFld.delegate = delegate as? UITextFieldDelegate
        }
        PMView.arr.append(txtFld)
    }
    
    @IBAction func KeyboardDoneTapped(_ textField: UITextField)
    {
        let filteredViews = PMView.arr.filter {$0.tag == textField.tag + 1}
        if filteredViews.count > 0
        {
            if filteredViews.first is UITextField
            {
                let passfld = filteredViews.first as! UITextField
                passfld.becomeFirstResponder()
            }
        }
    }
    
    fileprivate func labelTagAndTitle(typeTitle:Bool) -> (fontSize: CGFloat, numberLines: Int)
    {
        if typeTitle
        {
            return (17,3)
        }
        else
        {
            return (13,0)
        }
    }
    
    fileprivate func txtFldType(txtFldType:TxtFldType) -> (IsSecureTxtFld:Bool,KeybrdType:UIKeyboardType, txtFldTag:Int)
    {
        let objTxtFldType = txtFldType
        switch objTxtFldType
        {
        case .Default:
            return (false, .emailAddress, 200)
        case .Secure:
            return (true, .default, 201)
        }
    }
    
    fileprivate func setValueForType()
    {
        let objType = objPMAlertViewType!
        switch objType
        {
        case .Done:
            doneSet()
            break
        case .Cancel:
            doneAndCancelSet()
            break
        case .Ok:
            OkSet()
            break
        case .Confirm:
            ConfirmSet()
            break
        case .Waiting:
            Waiting()
            break
        case .TxtFld:
            TxtFld()
            break
        }
    }
    
    fileprivate func doneSet()
    {
        PMView.imgView.image = #imageLiteral(resourceName: "Done")
        AddButtonsForType(type: [.Done])
    }
    
    fileprivate func doneAndCancelSet()
    {
        PMView.imgView.image = #imageLiteral(resourceName: "Cancel")
        AddButtonsForType(type: [.Cancel])
    }
    fileprivate func OkSet()
    {
        PMView.imgView.image = #imageLiteral(resourceName: "Ok")
        AddButtonsForType(type: [.Ok])
    }
    fileprivate func ConfirmSet()
    {
        PMView.imgView.image = #imageLiteral(resourceName: "QuestionMark")
        AddTwoButtonsForType(type: [.No, .Yes])
    }
    
    fileprivate func Waiting()
    {
        addActivityONImage()
       // calulateSize()
    }
    
    fileprivate func TxtFld()
    {
        AddTwoButtonsForType(type: [.Ok, .Cancel])
      //  calulateSize()
    }
    
    fileprivate func AddButtonsForType(type:[ButtonType])
    {
        for typee in type
        {
            buttonType(type:typee)
        }
     //   calulateSize()
    }
    
    fileprivate func AddTwoButtonsForType(type:[ButtonType])
    {
        TwobuttonInRowType(type: type)
    }
    
    fileprivate func buttonType(type:ButtonType)
    {
        let buttonDone = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 44)) // note height is not setting here this is for only calulating for view
        let buttonTagTitle = buttonTagAndTitle(type: type)
        buttonDone.tag = buttonTagTitle.tag
        buttonDone.setTitle(buttonTagTitle.btnTitle, for: .normal)
        buttonDone.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        buttonDone.backgroundColor = buttonTagTitle.color
        buttonDone.heightAnchor.constraint(equalToConstant: 44).isActive = true
        buttonDone.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
         PMView.arr.append(buttonDone)
    }
    
    fileprivate func TwobuttonInRowType(type:[ButtonType])
    {
        var xButtonAxis : CGFloat = 0.0
        let viewToAdd = UIView(frame: CGRect(x: 0, y: 0, width: PMView.frame.size.width, height: 44))
        for typee in type
        {
            let buttonDone = UIButton(frame: CGRect(x: xButtonAxis, y: 0, width: viewToAdd.frame.width/2, height: 44)) // note height is not setting here this is for only calulating for view
            let buttonTagTitle = buttonTagAndTitle(type: typee)
            buttonDone.tag = buttonTagTitle.tag
            buttonDone.setTitle(buttonTagTitle.btnTitle, for: .normal)
            buttonDone.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            buttonDone.backgroundColor = buttonTagTitle.color
            buttonDone.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin]
            buttonDone.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            viewToAdd.addSubview(buttonDone)
            xButtonAxis = buttonDone.frame.size.width
            
        }
        viewToAdd.heightAnchor.constraint(equalToConstant: 44).isActive = true
        PMView.arr.append(viewToAdd)
    }
    
    fileprivate func addActivityONImage()
    {
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        myActivityIndicator.center = CGPoint(x: PMView.imgView.frame.size.width / 2, y: PMView.imgView.frame.size.height / 2)
        myActivityIndicator.startAnimating()
        PMView.imgView.addSubview(myActivityIndicator)
        PMView.imgView.backgroundColor = .gray
    }
    
    fileprivate func buttonTagAndTitle(type:ButtonType) -> (tag: Int, btnTitle: String, color:UIColor)
    {
        switch type
        {
        case .Ok:
            return (10,"Ok",.blue)
        case .Done:
            return (20,"Done",.green)
        case .Cancel:
            return (30,"Cancel",.red)
        case .Yes:
            return (40,"Yes",.green)
        case .No:
            return (50,"No", .red)
        }
    }
    
    
    
    fileprivate func calulateSize()
    {
        var height = 0
        height = Int(PMView.collectionView.contentSize.height) + Int(PMView.imgView.frame.size.height) + 10 // 10 for spacing 10 bottom of collectionview
        PMView.frame = CGRect(x: 25, y: objWindow.frame.origin.y + PMView.frame.size.height/2, width: objWindow.frame.size.width - 50, height: CGFloat(height))
        PMView.center = CGPoint(x: objWindow.bounds.midX, y: objWindow.bounds.midY - 50)
    }
    
    
    @IBAction func buttonTapped(sender:UIButton)
    {
        print(sender.tag)
        hidePM()
        guard objPMAVDelgate != nil else
        {
            return
        }
        let objType = objPMAlertViewType!
        switch objType
        {
        case .Done:
            objPMAVDelgate?.PMAVTapped(buttonIndex: 0)
            break
        case .Cancel:
            objPMAVDelgate?.PMAVTapped(buttonIndex: 0)
            break
        case .Ok:
            objPMAVDelgate?.PMAVTapped(buttonIndex: 0)
            break
        case .Confirm:
            objPMAVDelgate?.PMAVTapped(buttonIndex: sender.tag == 50 ? 0 : 1)
            break
        case .Waiting:
            break
        case .TxtFld:
            objPMAVDelgate?.PMAVTapped(buttonIndex: sender.tag == 10 ? 0 : 1)
            break
        }
    }
}
fileprivate extension UIView {
    
    func dropShadow()
    {
        self.layer.shadowOpacity = 2.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 20.0
    }
    
    func RoundCornerView()
    {
        self.layer.cornerRadius = 5.0
    }
}

extension PMAlertView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == arr.count - 1 {
     //       calulateSize()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if arr.count > 0
        {
            return arr.count
        }
        else
        { return 0}
        
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let view = arr[indexPath.row]
        view.frame = CGRect(x: 0, y: 0, width: collectionView.frame.size.width, height: cell.frame.size.height)
        cell.addSubview(view)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if arr[indexPath.row] is UILabel
        {
            let label = arr[indexPath.row] as! UILabel
            let maxSizee = CGSize(width: collectionView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
            let actualSize = label.text?.boundingRect(with: maxSizee, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font: label.font], context: nil)
            return CGSize(width: collectionView.frame.width, height: actualSize!.height)
        }
        else
        {
            let view = arr[indexPath.row]
            return CGSize(width:  collectionView.frame.width, height:  view.frame.size.height)
        }
     }
}

