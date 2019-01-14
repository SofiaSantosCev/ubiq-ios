
import UIKit

class misSitiosTVC: UITableViewController {

    var sitios = [Sitio]() //Array contenedora de ubicaciones
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is DetalleVC {
            let destination = segue.destination as! DetalleVC
            let sitio = sender as! misSitiosTVCell
            
            destination.Titulo.text = sitio.name.text!
            destination.fechaDesde = sitio.fechaDesde
            destination.fechaHasta = sitio.fechaHasta
            
        }
    }
    

}
