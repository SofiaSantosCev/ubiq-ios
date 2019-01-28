
import UIKit
import Alamofire


class misSitiosTVC: UITableViewController {
    var token = UserDefaults.standard.object(forKey: "token")
    var sitios = [Sitio]()
    //Se cargan los datos en las celdas
    override func viewDidLoad() {
        super.viewDidLoad()
        listaSitios()
    }
    
    //Obtener sitios guardados peticion get. Meterlos en array sitios
    func listaSitios(){
        let headers: HTTPHeaders = [
            "Authorization":UserDefaults.standard.object(forKey: "token") as! String
        ]
        
        Alamofire.request("http://localhost:8888/ubiq/public/index.php/api/location", method: .get, headers: headers)
            .responseJSON { response in
                let responseJSON = response.result.value as! [String: Any]
                if response.response?.statusCode == 200 {
                    let data = responseJSON["locations"] as! [[String:Any]]
                    for x in data {
                        let location = Sitio(titulo: x["name"] as! String,
                                             descripcion: (x["description"] as? String)!,
                                             dateDesde: x["start_date"] as! String,
                                             dateHasta: x["end_date"] as! String,
                                             longitude: x["x_coordinate"] as! Double,
                                             latitude: x["y_coordinate"] as! Double,
                                             user_id: x["user_id"] as! Int) 
                        self.sitios.append(location)
                        print(location)
                        self.tableView.reloadData()
                    }
                }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sitios.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! misSitiosTVCell
        
        cell.name.text = sitios[indexPath.row].titulo
        cell.fechaDesde.text = sitios[indexPath.row].dateDesde
        cell.fechaHasta.text = sitios[indexPath.row].dateHasta
        cell.id = indexPath.row
        return cell
        print(cell.name.text, cell.fechaDesde.text, cell.fechaDesde.text)
    }
    
    //Enviar datos de misSitiosTVCell(celda) a DetalleVC(vista detalle spot)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is DetalleVC {
            let destination = segue.destination as! DetalleVC
            let sender = sender as! misSitiosTVCell
            
            destination.sitio = sitios[sender.id!]
            
            
        }
    }
}
