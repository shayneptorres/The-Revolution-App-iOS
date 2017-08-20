//
//  FormCell.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/15/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

protocol FormCellDelegate {
    func updateValue(text: String, index: Int)
}

class FormCell: UITableViewCell, UITextFieldDelegate {

    
    @IBOutlet weak var field: JVFloatLabeledTextField!
    
    var delegate : FormCellDelegate?
    var index : Int?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let index = index else { return }
        delegate?.updateValue(text: text, index: index)
    }
    
}
