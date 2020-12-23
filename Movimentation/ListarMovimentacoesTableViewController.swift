//
//  ListarMovimentacoesTableViewController.swift
//  Movimentation
//
//  Created by Fabio Pizanelli Zinato on 12/18/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit
import CoreData

class ListarMovimentacoesTableViewController: UITableViewController {

    var context:NSManagedObjectContext!
    var movimentacoes: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        context = appDelegate.persistentContainer.viewContext
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        recuperarMovimentacoes()        
    }

    func recuperarMovimentacoes(){
        
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Movement")
        
        let ordenacao = NSSortDescriptor.init(key: "data", ascending: false)
        
        requisicao.sortDescriptors = [ordenacao]
        
        do {
            let movimentacoesRecuperadas = try context.fetch(requisicao)
            
            self.movimentacoes = movimentacoesRecuperadas as! [NSManagedObject]
            
            self.tableView.reloadData()
            
            print("Recuperou \(movimentacoes.count) Movimentacoes")
            
        } catch let erro {
            print("Erro ao recuperar Movimentacoes : \(erro.localizedDescription) ")
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.movimentacoes.count
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        
        let movimentacao = self.movimentacoes[indexPath.row]
        
        let descricaoRecuperado = movimentacao.value(forKey: "descricao")
        let dataRecuperada = movimentacao.value(forKey: "data")
        let tipoRecuperado = movimentacao.value(forKey: "tipo")
        let valorRecuperado = movimentacao.value(forKey: "valor")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/mm/yyyy hh:mm"
        
        let novaData = dateFormatter.string(from: dataRecuperada as! Date)
        
        var valorString = valorRecuperado as! Decimal
        
        print("Valor String \(valorString)")
        
        cell.textLabel?.text = descricaoRecuperado as? String
        let val = String(format:"Data: %@ - Valor: %@ - Tipo: %@", novaData, valorString.description, tipoRecuperado as! String)
        
        cell.detailTextLabel?.text = String(describing: val)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        let movimentacao = self.movimentacoes[indexPath.row]
        self.performSegue(withIdentifier: "verMovimentacao", sender: movimentacao)
        
    }

   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let movimentacao = self.movimentacoes[indexPath.row]
            
            self.context.delete(movimentacao)
            
            self.movimentacoes.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                
                try self.context.save()
                
                print("Movimentacao Removida Com Sucesso")
                
            } catch let erro {
                print("Erro ao Remover Movimentacao : \(erro.localizedDescription) ")
            }
            
        }
    }



    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "verMovimentacao"{
            let viewDestino = segue.destination as! ViewController
            viewDestino.movimentacao = sender as? NSManagedObject
        }
        
    }
    

}
