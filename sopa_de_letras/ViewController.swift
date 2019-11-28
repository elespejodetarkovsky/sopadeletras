//
//  ViewController.swift
//  sopa_de_letras
//
//  Created by Mati on 25/11/2019.
//  Copyright © 2019 Mati. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lblBonus: UILabel!
    @IBOutlet weak var lblPuntos: UILabel!
    @IBOutlet weak var lblCheck: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func newGame(_ sender: Any) {
        
        //inicio de variable y label
        lblTime.text = "30"
        self.segJuegos = 30
        
        //reinicio tabla
        self.correctsWords = []
        self.tableView.reloadData()
        
        //reinicio variable estado de inicio
        self.newGame = false
        
        //reinicio collection
        self.lettersAndVocals = crearLaSopa()
        collectionLetter.reloadData()
        
        //limpio la palabra
        self.lblWord.text = ""
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        correctsWords.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell:TableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableViewCell
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "mycell")
        
        cell.textLabel?.text = self.correctsWords[indexPath.row]
        

        return cell
        
    }
    
    
    
    @IBAction func chekWord(_ sender: Any) {
        /*
         esta función realizará un match entre la palabra
         introducida y un diccionario (o API)
         para poder validarla y agregarla a la lista
         */
    
            self.lblCheck.text = "evaluando..."
            self.lblCheck.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        
        var word: String = self.lblWord.text ?? ""
    
        do {
        
            try Utilidades.validate(word)
            
            var match: Bool = false
            
                //aquí hace la consulta
                Utilidades.consulta(word: word, completion:{ result in
                    
                    print(result)
                    
                    if result == true {
                        
                        //evaluo si se ha introducido ya
                        if self.correctsWords.firstIndex(of: word) == nil {
                            
                            self.correctsWords.append(self.lblWord.text!)
                            self.tableView.reloadData()
                            self.lblCheck.text = "correcto"
                            self.lblCheck.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                            
                            //libero los botones
                            self.releaseButtons()
                            
                            //borro la palabra correcta
                            self.lblWord.text = ""
                            
                            
                        } else {
                            
                            self.lblCheck.text = "ya introducida"
                        }
                        
                    } else {
                        
                        self.lblCheck.text = "incorrecto"
                        self.lblCheck.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                        
                    }

                    
                })
                

            
        } catch Utilidades.ValidationError.emptyWord {
            
            self.lblCheck.text = "palabra vacía"
            self.lblCheck.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            
        } catch {
            
            print("Error desconocido")
            
        }
        
        
        
    }
    
    
    @IBOutlet weak var lblWord: UILabel!
    
   
    @IBOutlet weak var lblTime: UILabel!
    
    
    var letters:[String] = []
    
    var vocals:[String] = []
    
    var lettersAndVocals:[String] = []
    
    var timer: Timer = Timer.init()

    var newGame: Bool = false
    
    var segJuegos: Int = 30
    
    var correctsWords: [String] = []
    
    var puntosActuales: Int = 0
    
    var bonus: Int = 0
    
    var game: Game = Game(puntos: 0, periodo: 1)
    
    var periodoActual: Int = 1
    
    
    @IBOutlet weak var collectionLetter: UICollectionView!
    
    @IBAction func delClick(_ sender: UIButton) {
        
        //Recupero la cadena
        
        
        
        //cell.backgroundColor = UIColor.blueColor()
        
        
        let word: String = lblWord.text ?? "Error"
        
        
        //usar if let aquí
        let lastLetter: Character = (word.last ?? nil)!
        
        print(lastLetter)
        
        let changeWord = word.dropLast()
        
        print(changeWord)
        lblWord.text = String(changeWord)
        
        var i: Int = 0
        
        print("el numero de items en la collection es: ",
              collectionLetter.numberOfItems(inSection: 0))
        
        while i < collectionLetter.numberOfItems(inSection: 0) {
            
            var indexPath = NSIndexPath(row: i, section: 0)
            //        let cell = collectionLetter.cellForItem(at: indexPath as IndexPath)
            //        ce
            
            //var cell = collectionLetter.dequeueReusableCell(withReuseIdentifier: "cellLetter", for: indexPath as IndexPath) as! LetterViewCell
            
            let cell = collectionLetter.cellForItem(at: indexPath as IndexPath) as! LetterViewCell
            
            let character: String = cell.buttonLetter.currentTitle!
            
            print("el caracter del boton es: ", character)
            
            if (character == String(lastLetter)) {
                //evaluo si coincide y se vuelve a activar
                
                cell.buttonLetter.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                cell.buttonLetter.isSelected = false
                i = 10
            
                
            } else {
                
                i += 1
            }

        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //letters.count
        lettersAndVocals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: "cellLetter", for: indexPath) as! LetterViewCell
        
        cell.buttonLetter.setTitle(lettersAndVocals[indexPath.row], for: .normal)
        
        cell.buttonLetter.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        cell.buttonLetter.isSelected = false
        
        return cell
        
    }
    
    @IBAction func clickLetter(_ sender: UIButton) {
        
        
        //se ejecuta el código si el boton
        //se encuentra en false (que no se ha presionado)
        
        
        if sender.isSelected == false {
         
            var letter: String = sender.titleLabel?.text ?? ""
            
            //cambiamos el estado del boton a presionado
            sender.isSelected = true
            
            sender.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            
            print(sender.titleLabel?.text ?? "")
            
            
            //utilizar append
            self.lblWord.text! += letter
            
            //inicio el juego si es la primera letra
            if self.newGame == false {
                
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
                
                self.newGame = true
            }
            
        }
    }
    
    @objc func fire() {
        
        //esta funcion inicia el conteo
        //var segActuales:Int = Int(self.lblTime.text)
    
        self.segJuegos -= 1
        
        //coloco en el struct game
        //el periodo que le corresponda
        
        if self.segJuegos % 5 == 0 {
            self.game.periodo += 1
            
            print("periodo: ", self.game.periodo)
        }
        
        
        if self.segJuegos <= 0 {
            
            lblTime.text = String("fin partida")
            self.newGame = false
            self.timer.invalidate()
            
        } else {
            
            lblTime.text = String(self.segJuegos)
            
        }
        
        
    }

    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.lblWord.text = ""
        self.lblTime.text = "30"

        print(self.game)
        
        self.lettersAndVocals = crearLaSopa()
            
        
        
    }
    
    func crearLaSopa () -> [String] {
        
        /*
         Creará un array de botones
         que se utilizará en el collectionView
         */
        
        //primero extraigo al azar letras
        
        self.letters = ["B", "C", "D","F", "G", "H",
                        "J","K","L","M","P","Q","R","S","T","W","X","Z"]
        
        self.vocals = ["A", "E", "I", "O", "U"]
        
        //array vacio
        var arraySopa: [String] = []
        
        
        //Selecciono 5 letras
        for i in 0...5 {
            
            print("indice: ", i , "letra: ", letters.randomElement())
            
            arraySopa.append(letters.randomElement()!)
            
            
        }
        
        //selecciono 4 vocales
        for i in 6...9 {
            
            print("indice: ", i , "vocal: ", vocals.randomElement())
            
            //haré lo mismo para las vocales
            arraySopa.append(vocals.randomElement()!)
            
            
        }
        
        print(arraySopa)
    
        return arraySopa

    }
    
    func releaseButtons () {
        
        /*
         esta funcion limpiará y volverá a habilitar
         los botones de la collection
        */

        let items: Int = collectionLetter.numberOfItems(inSection: 0) - 1
        
        for i in 0...items {
            
            var indexPath = NSIndexPath(row: i, section: 0)
            
            //var cell = collectionLetter.dequeueReusableCell(withReuseIdentifier: "cellLetter", for: indexPath as IndexPath) as! LetterViewCell
            
            let cell = collectionLetter.cellForItem(at: indexPath as IndexPath) as! LetterViewCell
            
            
            cell.buttonLetter.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            cell.buttonLetter.isSelected = false
            
            print("libero el button: ", cell.buttonLetter.titleLabel?.text)
            

        }
        
    }
    
    func wordPoint () -> Void{
        
        /*
         esta funcion evaluará en funcion del tiempo y el bonus
         acumulado cuantos puntos tendrá
         */
        
        /*
         Evaluo que esté en el mismo período que en el anterior
         podría hacer un struct?
         */
        
        if periodoActual == self.game.periodo {
            self.game.bonus += 1
            self.game.puntos = 
        }
        self.lblPuntos.text = String(self.puntosActuales)
        self.lblBonus.text = String(self.bonus)
        
        
        
        
        
        
        
        
    }

}
