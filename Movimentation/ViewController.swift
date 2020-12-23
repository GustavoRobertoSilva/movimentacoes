//
//  ViewController.swift
//  Movimentation
//
//  Created by Gustavo Silva on 12/14/20.
//  Copyright © 2020 home. All rights reserved.
//
//https://www.ioscreator.com/tutorials/display-date-date-picker-ios-tutorial

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let tipos = ["Debito","Credito"]
    
    @IBOutlet weak var descricao: UITextView!
    @IBOutlet weak var tipo: UITextField!
    
    @IBOutlet weak var dataSelecionada: UIDatePicker!
    
    @IBOutlet weak var data: UITextView!
    @IBOutlet weak var valor: UITextField!
    
    var context: NSManagedObjectContext!
    var movimentacao: NSManagedObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.dataSelecionada.becomeFirstResponder()
        
        if movimentacao != nil{
            if let descricaoRecuperada = movimentacao.value(forKey: "descricao"){
                self.descricao.text = String(describing: descricaoRecuperada)
            }
            if let valorRecuperado = movimentacao.value(forKey: "valor"){
                self.valor.text = String(describing: valorRecuperado)
            }
            if let tipoRecuperado = movimentacao.value(forKey: "tipo"){
                self.tipo.text = String(describing: tipoRecuperado)
            }
            if let dataRecuperada = movimentacao.value(forKey: "data"){
                self.data.text = String(describing: dataRecuperada)
            }
            
//            if let dataSelecionadaRecuperada = movimentacao.value(forKey: "data"){
//                self.dataSelecionada.date = dataSelecionadaRecuperada
//            }
            
        }else{
            self.descricao.text = ""
            self.valor.text = ""
            self.tipo.text = ""
            self.data.text = ""
            self.dataSelecionada.date = Date();
        }
               
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    }
    
    @IBAction func salvar(_ sender: Any) {
               
        if movimentacao == nil{
            self.salvar()
        }else{
            self.atualizar()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func salvar(){
        
        let movimentation = NSEntityDescription.insertNewObject(forEntityName: "Movement", into: context)
        
        movimentation.setValue(self.descricao.text, forKey: "descricao")
        movimentation.setValue(self.dataSelecionada.date, forKey: "data")
        movimentation.setValue(self.tipo.text, forKey: "tipo")
        movimentation.setValue(Decimal(string: self.valor.text!), forKey: "valor")
        
        do {
            try context.save()
            print("Movimentacao Salva com Sucesso !!!!")
        } catch let erro {
            print("Erro ao Salvar a Movimentacao: \(erro.localizedDescription)")
        }
        
    }
    
    func atualizar(){
        
        movimentacao.setValue(self.descricao.text, forKey: "descricao")
        movimentacao.setValue(self.dataSelecionada.date, forKey: "data")
        movimentacao.setValue(self.tipo.text, forKey: "tipo")
        movimentacao.setValue(Decimal(string: self.valor.text!), forKey: "valor")
        
        do {
            try context.save()
            print("Movimentacao Atualizada com Sucesso !!!!")
        } catch let erro {
            print("Erro ao Atualizar a Movimentacao: \(erro.localizedDescription)")
        }
        
    }
    

}

