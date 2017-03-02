//
//  newEventVC.swift
//  countdown
//
//  Created by evdodima on 12/02/2017.
//  Copyright © 2017 Evdodima. All rights reserved.
//

import UIKit
import CoreData

class newEventVC: UITableViewController {
        
    let textFieldSectionIndex = 0
    let nameCellIndex = 0
    
    let pickersDateSectionIndex = 1
    let startPickerIndex = 1
    let datePickerCellHeight = 216;
    
    let imageCellHeight = 100
    
    var event: Event? = nil
    var events: [Event]? = nil
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var startLabel: UITextField!
    
    @IBOutlet weak var startPicker: UIDatePicker!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    var selectedImage: UIImage! = sampleImages[0]
    

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        var event: Event? = nil
        
        if self.event != nil {
            event = self.event
            event!.name = nameField.text!
            event!.date = startPicker.date
            event!.bgImage = selectedImage
        } else {
            event = Event(name:nameField.text!,
                              date:startPicker.date,
                              creationDate: Date(), bgImage : selectedImage)
        }
        saveEvent(event: event!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        startLabel.text = sender.date.asString()
        if self.event != nil {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
       
    }

    @IBAction func nameEditingChanged(_ sender: Any) {
            navigationItem.rightBarButtonItem?.isEnabled = (!nameField.text!.isEmpty)
    }
    
    
    @IBAction func unwindToEvent(segue: UIStoryboardSegue) {
        if self.event != nil {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }

    
    
    func setupDatePickers(){
        if (event != nil) {
            startPicker.date = event!.date
        } else {
            startPicker.date = Date()
        }
        startPicker.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
    func setupLabels(){
        startLabel.text = startPicker.date.asString()
        if (event != nil) {
            nameField.text = event?.name
        }
    }
    
    func setupImageView(){
        if (event != nil) {
            selectedImage = event!.bgImage
        }
        selectedImageView.image = selectedImage
    }
    
    func saveEvent(event : Event){
        
        if self.event != nil {
            events![events!.index(of: event)!] = event
            
        } else {
            events!.append(event)
        }
        NSKeyedArchiver.archiveRootObject(events!, toFile: filePath)
        self.event = nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePickers()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        setupLabels()
        setupImageView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedImageView.image = selectedImage
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = self.tableView.rowHeight;
        
        if (indexPath.section == pickersDateSectionIndex && indexPath.row == startPickerIndex) {
            height = CGFloat((self.startPicker.isHidden) ? 0 : datePickerCellHeight);
        }
        
        if  (indexPath.section == 2) {
            height = CGFloat(imageCellHeight)
        }
        
        return height;

    }
    
    override func tableView(_: UITableView, didSelectRowAt: IndexPath) {
        tableView.deselectRow(at: didSelectRowAt, animated: true)
        
        if ( (didSelectRowAt.row != nameCellIndex) )
            || (didSelectRowAt.section != textFieldSectionIndex)
        {
            hideKeyboard()
        }
        
        if (didSelectRowAt.section == pickersDateSectionIndex){
            if (didSelectRowAt.row == startPickerIndex-1){
                startPicker.isHidden ?
                    showCell(forDatePicker: startPicker):
                    hideCell(forDatePicker: startPicker)
            }
        }

    }
    
    func showCell(forDatePicker: UIDatePicker){
        forDatePicker.isHidden = false
        forDatePicker.alpha = 0.0
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.animate(withDuration: 0.4,
                       animations: { forDatePicker.alpha = 1.0}
                       )
    }
    
    func hideCell(forDatePicker: UIDatePicker){
        forDatePicker.isHidden = true
    
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.animate(withDuration: 0.25,
                       animations: { forDatePicker.alpha = 0.0}
        )
    }
    
    func keyboardWillShow(){
        hideCell(forDatePicker: startPicker)
    }
    
    func hideKeyboard(){
        nameField.resignFirstResponder()
    }
}
