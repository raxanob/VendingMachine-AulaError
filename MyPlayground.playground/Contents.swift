import Foundation

class VendingMachineProduct {
    var name: String
    var amount: Int
    var price: Int
    
    init(name: String, amount: Int, price: Int){
        self.name = name
        self.amount = amount
        self.price = price
    }
}

//TODO: Definir os erros
enum VendingMachineError: Error {
    case productNotFound
    case productUnavailable
    case productStuck
    case insufficientFunds
    case sufficientFunds
    case moreFunds
}

extension VendingMachineError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .productNotFound:
            return "Acabou o produto"
        case .productUnavailable:
            return "Acabou isso ai"
        case .productStuck:
            return "Intalô"
        case .insufficientFunds:
            return "Ta faltando dinheiro nisso ai"
        case .sufficientFunds:
            return "No ponto"
        case .moreFunds:
            return "Obrigado pela gorjeta"
        }
    }
}

class VendingMachine {
    private var estoque: [VendingMachineProduct]
    private var money: Int
    
    init(products: [VendingMachineProduct]) {
        self.estoque = products
        self.money = 0
    }
    
    func getProduct(named name: String, with money: Int) throws {
        
        //TODO: receber o dinheiro e salvar em uma variável
        self.money += money
        
        //TODO: achar o produto que o cliente quer
        let produtoOptional = estoque.first { (produto) -> Bool in
            return produto.name == name
        }
        guard let produto = produtoOptional else { throw VendingMachineError.productNotFound }
        
        //TODO: ver se ainda tem esse produto
        guard produto.amount > 0 else { throw VendingMachineError.productUnavailable }
        
        //TODO: ver se o dinheiro é o suficiente pro produto
        guard produto.price < self.money else { throw VendingMachineError.insufficientFunds }
        
        //TODO: Deu dinheiro a mais ai
        guard produto.price > self.money else { throw VendingMachineError.moreFunds }
        
        guard produto.price == self.money else { throw VendingMachineError.sufficientFunds }
        
        //TODO: entregar o produto
        self.money -= produto.price
        produto.amount -= 1
        
        if Int.random(in: 0...100) < 10 {
            throw VendingMachineError.productStuck
        }
        
    }
    
    func getTroco() -> Int {
        //TODO: devolver o dinheiro que não foi gasto
        defer {
            self.money = 0
        }
        return self.money
    }
}

let vendingMachine = VendingMachine(products: [
    VendingMachineProduct(name: "Carregador de iPhone", amount: 5, price: 150),
    VendingMachineProduct(name: "Funniuns", amount: 2, price: 2),
    VendingMachineProduct(name: "Umbrella", amount: 5, price: 150),
    VendingMachineProduct(name: "Trator", amount: 1, price: 150000)
])

do {
    try vendingMachine.getProduct(named: "Umbrella", with: 150)
    print ("No ponto em")
} catch VendingMachineError.productStuck{
    print("Pedimos desculpa, mas seu produto ficou preso")
} catch {
    print (error.localizedDescription)
}
