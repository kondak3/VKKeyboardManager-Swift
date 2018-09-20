//
//  VKKeyboardManager.swift
//  KeyboardManager
//
//  Created by Kondaiah V on 9/3/18.
//  Copyright © 2018 Kondaiah Veeraboyina. All rights reserved.
//

import UIKit

class VKKeyboardManager: NSObject {

    // instance...
    static let shared = VKKeyboardManager()
    
    // default gap between keyboard and textfiled/textview...
    var keyboard_gap: Float = 5.0
    private var _initialize: Bool = false
    
    // textfiled for assign..
    private var _textField: UITextField?
    
    // textview for assign..
    private var _textView: UITextView?
    
    // toolbar...
    private var _toolBar: UIToolbar?
    
    // placeholder message lable...
    private var _placeholder: UILabel?
    
    // done button for keyboard resign...
    private var _doneBtn: UIButton?
    
    // MARK:-
    // enable keyboard manager...
    func setEnable() -> Void {
        
        // default gap...
        if keyboard_gap == 0.0 {
            keyboard_gap = 5.0
        }
        
        // add element only once...
        if (!_initialize) {
            
            _initialize = false
            create_toolbar()
            add_observers()
        }
    }
    
    private func create_toolbar() -> Void {
        
        // parent view creations...
        let parent_view = UIView.init()
        parent_view.frame = CGRect.init(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width - 40), height: tool_height)
        parent_view.backgroundColor = UIColor.clear
        
        // done buttons...
        _doneBtn = UIButton.init(type: .custom)
        _doneBtn?.frame = CGRect.init(x: Int(UIScreen.main.bounds.size.width - 50), y: 0, width: 50, height: tool_height)
        _doneBtn?.backgroundColor = UIColor.clear
        _doneBtn?.setTitle("Done", for: .normal)
        _doneBtn?.setTitleColor(UIColor.init(red: 30.0/255.0, green: 150.0/255.0, blue: 255.0/255.0, alpha: 1.0), for: .normal)
        _doneBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        _doneBtn?.addTarget(self, action: #selector(dismissKeyboardMethod), for: .touchUpInside)
        parent_view.addSubview(_doneBtn!)
        
        // place holder label...
        _placeholder = UILabel.init()
        _placeholder?.frame = CGRect.init(x: 115/2, y: 0, width: Int(parent_view.frame.size.width - 115), height: tool_height)
        _placeholder?.textColor = UIColor.gray
        _placeholder?.textAlignment = .center
        _placeholder?.numberOfLines = 2
        _placeholder?.minimumScaleFactor = 8
        _placeholder?.font = UIFont.systemFont(ofSize: 12)
        _placeholder?.backgroundColor = UIColor.clear
        parent_view.addSubview(_placeholder!)
        
        // tool bar allocations...
        let button_items = UIBarButtonItem.init(customView: parent_view)
        _toolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: 320, height: 50))
        _toolBar?.items = [button_items]
        _toolBar?.sizeToFit()
    }
    
    private func add_toolbar() -> Void {
        
        // tool bar width....
        let final_width = UIScreen.main.bounds.size.width - 40
        _doneBtn?.frame = CGRect.init(x: Int(final_width - 50), y: 0, width: 50, height: tool_height)
        _placeholder?.frame = CGRect.init(x: 115/2, y: 0, width: Int(final_width - 115), height: tool_height)
        
        // assign tool bar to textfiled/textview...
        if _textField != nil {
            _placeholder?.text = _textField?.placeholder
            _textField?.inputAccessoryView = _toolBar
        }
        else if _textView != nil {
            _placeholder?.text = ""
            _textView?.inputAccessoryView = _toolBar
        }
        else {}
    }
    
    // dealloc method in swift...
    deinit {
        
        // perform the deinitialization...
        NotificationCenter.default.removeObserver(self,
                                                  name: .UITextFieldTextDidBeginEditing,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .UITextFieldTextDidEndEditing,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .UITextViewTextDidBeginEditing,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .UITextViewTextDidEndEditing,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillShow,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillHide,
                                                  object: nil)
    }
}

extension VKKeyboardManager {
    
    private func getController(childView: UIView) -> UIViewController? {
        
        // getting parent ctrl...
        var nextResponder: UIResponder? = childView
        repeat {
            
            // move to next responder...
            nextResponder = nextResponder?.next
            if (nextResponder is UIViewController) {
                // getting final controller...
                return (nextResponder as? UIViewController)!
            }
            
        } while nextResponder != nil
        return nil
    }
    
    private func getController() -> UIViewController? {
        
        // getting textfiled/textview view control...
        if _textField != nil {
            return getController(childView: _textField!)
        }
        else if _textView != nil {
            return getController(childView: _textView!)
        }
        else {
            return nil
        }
    }
    
    private func add_observers() -> Void {
        
        // text field notifications...
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textField_textDidBeginEditing(notification:)),
                                               name: .UITextFieldTextDidBeginEditing,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textField_textDidEndEditing(notification:)),
                                               name: .UITextFieldTextDidEndEditing,
                                               object: nil)
        
        // text view notifications...
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textView_textDidBeginEditing(notification:)),
                                               name: .UITextViewTextDidBeginEditing,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textView_textDidEndEditing(notification:)),
                                               name: .UITextViewTextDidEndEditing,
                                               object: nil)
        
        // keyboard notifications...
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
    }
}

extension VKKeyboardManager {
    
    // MARK:-
    @objc private func keyboardWillShow(notification: Notification) -> Void {
        
        // getting textfield y-axis...
        let window = UIApplication.shared.keyWindow
        let fieldRect: CGRect!
        if _textField != nil {
            fieldRect = (window?.convert((_textField?.bounds)!, from: _textField))
        }
        else if _textView != nil {
            fieldRect = (window?.convert((_textView?.bounds)!, from: _textView))
        }
        else {
            UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
            return
        }
        
        // default height...
        if (keyboard_gap <= 5.0 || keyboard_gap >= 101.0) {
            keyboard_gap = 5.0
        }
        let yValue = fieldRect.size.height + fieldRect.origin.y + CGFloat(keyboard_gap)
        
        // screen height calculations...
        let screenSize = UIScreen.main.bounds
        var height = screenSize.height - yValue
        if height < 0 {
            height = 0
        }
        
        // if we didn't get view controller...
        let viewCtrl: UIViewController? = getController()
        if viewCtrl == nil {
            return
        }
        
        // getting keyboard height...
        let userInfo = notification.userInfo
        let kbSize: CGSize? = (userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue?.size
        let upperVal = -Float((kbSize?.height)!) + Float(height)
        
        // getting view controller "self" view
        let mainView = viewCtrl?.view
        if height < (kbSize?.height)! {
            
            // view move to up...
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                mainView?.frame = CGRect(x: 0, y: CGFloat(upperVal), width: (mainView?.frame.size.width)!, height: (mainView?.frame.size.height)!)
            })
        }
        else {
            
            // view move to down...
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                mainView?.frame = CGRect(x: 0, y: 0, width: (mainView?.frame.size.width)!, height: (mainView?.frame.size.height)!)
            })
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) -> Void {
        
        // if we didn't get view controller...
        let viewCtrl: UIViewController? = getController()
        if viewCtrl == nil {
            return
        }
        
        // getting view controller "self" view
        let mainView = viewCtrl?.view
        
        // view move to down...
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            mainView?.frame = CGRect(x: 0, y: 0, width: (mainView?.frame.size.width)!, height: (mainView?.frame.size.height)!)
        })
    }
    
    @objc private func dismissKeyboardMethod() -> Void {
        
        // resign keyboard...
        if _textField != nil {
            _textField?.resignFirstResponder()
        }
        else if _textView != nil {
            _textView?.resignFirstResponder()
        }
        else {}
    }
}

extension VKKeyboardManager {
    
    // MARK:-
    @objc private func textField_textDidBeginEditing(notification: Notification) -> Void {
        
        // getting textfield which one user editing...
        if notification.object! is UITextField {
            
            _textField = notification.object as? UITextField
            add_toolbar()
        }
    }
    
    @objc private func textField_textDidEndEditing(notification: Notification) -> Void {
        
        // at end editing remove textfiled...
        _textField = nil
    }
    
    @objc private func textView_textDidBeginEditing(notification: Notification) -> Void {
        
        // getting textview which one user editing...
        if notification.object! is UITextView {
            
            _textView = notification.object as? UITextView
            add_toolbar()
            _textView?.becomeFirstResponder()
            
        }
    }
    
    @objc private func textView_textDidEndEditing(notification: Notification) -> Void {
        
        // at end editing remove textview...
        _textView = nil
    }
}

// tool bar menu default height...
let tool_height = 35




