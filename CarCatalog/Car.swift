import Foundation

//класс, описывающий информацию  об авто. Реализует протокол LosslessStringConvertible, что позволяет записывать всю информацию о классе в строку и наоборот, из строки формировать объект класса Car
class Car: LosslessStringConvertible {
    
    var id: Int
    var issueYear: String
    var manufacturer: String
    var model: String
    var bodyStyle: String


    //возвращает строку с заголовками-названиями полей, добавлены доп. пробелы, чтоб лучше смотрелось в терминале
    public static func headerNames() -> String {
        var result = "id     "
        result += "Год выпуска     "
        result += "Производитель   "
        result += "Модель          "
        result += "Кузов     "
        return result
    }

    
    required init?(_ csvLine: String) {
        let values = csvLine.split(separator: ",")


        guard values.count == 5,
              let id = Int(values[0]) else {
            return nil
        }

        self.id = id
        self.issueYear = String(values[1])
        self.manufacturer = String(values[2])
        self.model = String(values[3])
        self.bodyStyle = String(values[4])
    }

    func csv() -> String {
        return "\(id),\(issueYear),\(manufacturer),\(model),\(bodyStyle)"
    }

    public var description: String {
        
        let idStringC = (String(id) as NSString).utf8String!
        let issueYearC = (issueYear as NSString).utf8String!
        let manufacturerC = (manufacturer as NSString).utf8String!
        let modelC = (model as NSString).utf8String!
        let bodyStyleC = (bodyStyle as NSString).utf8String!

        
        
        //используем строки в формате Си для того чтобы подставить их в строку-формат "%-6s %-16s%-16s%-16s%-10s" где например на место %-6s будет подставлена строка idStringC и дополнена пробелами так, чтобы занять 6 символов
        return String(format: "%-6s %-16s%-16s%-16s%-10s", idStringC, issueYearC, manufacturerC, modelC, bodyStyleC)
    }
}
