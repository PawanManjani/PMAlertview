//
//  ViewController.swift
//  MyAlertView
//
//  Created by Pavan Manjani on 20/11/17.
//  Copyright © 2017 SN. All rights reserved.
//

import UIKit

class ViewController: UIViewController,PMAlertViewDelegate,UITextFieldDelegate
{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showDone(_ sender: UIButton)
    {
        PMAlertView.SharePMAV.ShowPMA(title: "Alert Title", msg: "This Alert is for Done", type: .Done, PVDelegate: self)
        PMAlertView.SharePMAV.ShowImage(showImg: false)
    }
    
    @IBAction func showCancel(_ sender: UIButton)
    {
        PMAlertView.SharePMAV.ShowPMA(title: "Alert Title", msg: "This Alert is for Failure", type: .Cancel, PVDelegate: nil)
    }
    
    @IBAction func showOk(_ sender: UIButton)
    {
        PMAlertView.SharePMAV.ShowPMA(title: "Alert Title", msg: "This Alert is for Ok", type: .Ok, PVDelegate: self)
    }
    
    
    @IBAction func showConform(_ sender: UIButton)
    {
        PMAlertView.SharePMAV.ShowPMA(title: "Alert Title", msg: "This Alert is for Confirmation", type: .Confirm, PVDelegate: self)
    }
    
    @IBAction func showWaiting(_ sender: UIButton)
    {
        PMAlertView.SharePMAV.ShowPMA(title: "Waiting Title", msg: nil, type: .Waiting, PVDelegate: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0)
        {
            PMAlertView.SharePMAV.hidePM()
        }
    }
    
    @IBAction func showMultiline(_ sender: UIButton)
    {
        PMAlertView.SharePMAV.ShowPMA(title: "Alert Title and this is multiline alert, awesome na??", msg: "This Alert is for Ok and yes this is also multiline alert, cooool :)", type: .Done, PVDelegate: self)
    }
    
    @IBAction func showSingleTxtFld(_ sender: UIButton)
    {
        PMAlertView.SharePMAV.ShowPMAWithSingleTextFld(title: "Alert Title", msg: "This is for Single TextFld", placeHolderTxt: "Enter Your Name", PVDelegate: nil)
    }
    
    @IBAction func showEmailAndPassTxtFld(_ sender: UIButton)
    {
        PMAlertView.SharePMAV.ShowPMAWithEmailAndPassTextFld(title: "Alert Title", msg:  "This is for Email and Password TextFld", placeHolderTxt1: "Enter Email", placeHolderTxt2: "Enter Password", PVDelegate: self)
    }
    
    
    public func textFieldDidEndEditing(_ textField: UITextField)
    {
        print(textField.text ?? "n")
    }
    
    func PMAVTapped(buttonIndex:Int)
    {
        print(buttonIndex)
    }

}

