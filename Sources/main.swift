import Foundation

func loadPhrases() -> [String] {
    let fileURL = URL(fileURLWithPath: "frases.txt")
    do {
        let contents = try String(contentsOf: fileURL)
        let phrases = contents.components(separatedBy: .newlines).filter { !$0.isEmpty }
        return phrases
    } catch {
        print("Erro ao carregar o arquivo de frases.")
        return []
    }
}

func selectRandomPhrase(phrases: [String]) -> String? {
    guard !phrases.isEmpty else { return nil }
    return phrases.randomElement()
}

func addPhrase(phrase: String) {
    let fileURL = URL(fileURLWithPath: "frases.txt")
    do {
        let contents = try String(contentsOf: fileURL)
        let updatedContents = "\(contents)\n\(phrase)"
        try updatedContents.write(to: fileURL, atomically: true, encoding: .utf8)
    } catch {
        print("Erro ao adicionar nova frase.")
    }
}

func removePhrase(phrase: String) {
    let fileURL = URL(fileURLWithPath: "frases.txt")
    do {
        var contents = try String(contentsOf: fileURL)
        if contents.contains("\(phrase)\n") {
            contents = contents.replacingOccurrences(of:"\(phrase)\n", with: "")
        } else if contents.contains("\(phrase)") {
            contents = contents.replacingOccurrences(of: "\(phrase)", with: "")
        } else {
            print("frase não encontrada")
            return
        }
        try contents.write(to: fileURL, atomically: true, encoding: .utf8)
        print("Frase removida com sucesso")
    } catch {
        print("Erro ao remover frase.")
    }
}

func listFilteredPhrases(key: String) -> [String] {
    
    let fileURL = URL(fileURLWithPath: "frases.txt")
    do {
        let contents = try String(contentsOf: fileURL)
        let phrases = contents.components(separatedBy: .newlines)
        var phraseWhithKey = [String]()
        for phrase in phrases {
            if phrase.contains(key) {
                phraseWhithKey.append(phrase)
            }
        }
        return phraseWhithKey
    } catch {
        print("Erro ao realizar ação.")
        return []
    }
}

var phrases = loadPhrases()

var shouldExit = false

print("Sua frase aleatória é:")
let randomPhrase = selectRandomPhrase(phrases: phrases)
print(randomPhrase ?? "Não consegui achar nenhuma frase =/")

while !shouldExit {
    print("Escolha uma opção:\n1. Apresentar uma frase aleatória\n2. Deletar uma frase\n3. Adicionar uma nova frase\n4. Listar todas as frases\n5. Procurar por uma palavra chave\n6. Encerrar o programa")
    
    if let userMenuInput = readLine() {
        switch userMenuInput {
        case "1":
            let printPhrase = selectRandomPhrase(phrases: phrases)
            print(printPhrase ?? "Não há frases para apresentar.")
        case "2":
            print("Digite a frase que deseja remover:")
            if let removePhraseInput = readLine() {
                removePhrase(phrase: removePhraseInput)
                phrases = loadPhrases()
            }
            
        case "3":
            print("Digite a nova frase:")
            if let createPhraseUserInput = readLine() {
                addPhrase(phrase: createPhraseUserInput)
                phrases = loadPhrases()
            }
        case "4":
            print(phrases)
        case "5":
            print("Digite a palavra que deseja buscar:")
            let filterUserInput = readLine()
            let filteredPhrase = listFilteredPhrases(key: filterUserInput ?? "12")
            print(filteredPhrase)
        case "6":
            shouldExit = true
            print("Encerrando o programa...")
        default:
            print("Opção inválida.")
        }
    } else {
        print("Erro ao ler a entrada do usuário.")
    }
}
