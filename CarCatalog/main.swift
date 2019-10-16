import Foundation

let commands = ["exit", "list", "add", "edit", "rm"]
let mgr = CarManager()
CarManager.printAvailableCommands()

while true {
    let command = readLine()
    if let splitCommand = command?.split(separator: " "),
       commands.contains(String(splitCommand.first ?? "")) {
        let firstWord = String(splitCommand.first ?? "")

        if firstWord == "list" {
            mgr.listCars()
            continue
        }
        if firstWord == "add" {
            mgr.addCar()
            continue
        }
        if firstWord == "exit" {
            mgr.tryWrite()
            break
        }


        if splitCommand.count > 1,
           let id = Int(splitCommand[1]) {
            
            if firstWord == "edit" {
                mgr.editCar(id: id)
                continue
            } else {
                mgr.removeCar(id: id)
                continue
            }
        }

    }

    print("Не удалось выполнить команду, проверьте правильность ввода")

}

mgr.tryWrite() 
