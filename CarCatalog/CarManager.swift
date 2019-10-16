import Foundation


class CarManager {
    let fileName = "car_list.csv"
    var cars: [Int: Car] = [:]
    public var carCount: Int {
        return cars.count
    }

    
    public static func printAvailableCommands() {
        
        print("Список доступных команд:")

        
        
        var commandsWithDesc = ["list": "вывод всех записей", "rm <id>": "удаление записи с номером <id>",
                                "edit <id>": "изменение записи с номером <id>", "add": "добавление новой записи", "exit": "добавление новой записи"]

        for name in commandsWithDesc.keys.sorted() {
            let nameC = (name as NSString).utf8String!
            print(String(format: "%-10s", nameC), terminator: " ")
            print(commandsWithDesc[name]!)
        }
    }

    
    func addCars(_ cars: [Car]) {
        for car in cars {
            self.cars[car.id] = car
        }
    }

    
    public func removeCar(id: Int) {
        let removedCar = cars.removeValue(forKey: id)
        if removedCar == nil {
            print("Нет автомобиля с таким id")
        } else {
            tryWrite()
            print("Автомобиль удален.")
        }
    }

    public func editCar(id: Int) {
        guard let prev = cars[id] else {
            print("нет автомобиля с данным id")
            return
        }

        
        print(prev)
        print("укажите новые данные:")

        
        let text = readNewCarInfo(id)

        
        if let new = Car(text) {
            
            cars[prev.id] = new
            tryWrite()
            
            print("данные обновлены")
        } else {
            
            print("Не удалось создать запись, проверьте корректность введенных данных")
        }
    }

    
    func readNextLine(message: String) -> String {
        print(message)

        
        var text: String?
        text = readLine()
        
        while text == nil {
            print("не удалось считать значение, повторите ввод")
            print(message)
            text = readLine()
        }

        return text!
    }

   
    func readNewCarInfo(_ id: Int) -> String {
        
        var text = String(id) + ","

        let year = readNextLine(message: "год выпуска:")
        text += year + ","

        let manufacturer = readNextLine(message: "производитель:")
        text += manufacturer + ","

        let model = readNextLine(message: "модель:")
        text += model + ","

        let bodyStyle = readNextLine(message: "тип кузова:")
        text += bodyStyle

        return text
    }

    //добавление нового авто
    public func addCar() {
        print("укажите данные автомобиля:")

       
        let newId = (cars.keys.max() ?? 0) + 1
    
        let text = readNewCarInfo(newId)
        if let new = Car(text) {
            cars[new.id] = new
            tryWrite()
        } else {
            print("Не удалось создать запись, проверьте корректность введенных данных")
        }
    }

    // выводит список всех авто
    public func listCars() {
        if cars.count == 0 {
            print("Нет сохраненных записей об автомобилях.")
            return
        }

        print(Car.headerNames())
        
      
        for car in cars.values {
            print(car)
        }
    }

    
    //ининциализация объекта CarManager.
    init() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        
            let fileURL = dir.appendingPathComponent(fileName)

            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    let text = try String(contentsOf: fileURL, encoding: .utf8)
                    for line in text.split(separator: "\n") {
                        if let car = Car(String(line)) {
                            cars[car.id] = car
                        }
                    }
                } catch {
                    print("Не удалось загрузить данные из файла файл.")
                }
            } else {
                let car1 = Car("0,2012,Ford,Focus,sedan")!
                let car2 = Car("2,2018,Tesla,Tesla Model 3,sedan")!
                let car3 = Car("32,2002,Volvo,S80,sedan")!

                addCars([car1, car2, car3])
            }
        }
    }

    //функция для записи данных всех авто в файл
    public func tryWrite() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(fileName)
            
            
            var text = ""
            for car in cars.values {
                text += car.csv() + "\n"
            }

            do {
                try String(text).write(to: fileURL, atomically: false, encoding: .utf8)
            } catch {
                print("Не удалось сохранить изменения в файл.")
            }
        }
    }
}
