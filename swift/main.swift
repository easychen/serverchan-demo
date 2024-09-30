import Foundation

func sc_send(text: String, desp: String = "", key: String = "[SENDKEY]") -> String {
    let urlString: String
    if key.hasPrefix("sctp") {
        urlString = "https://\(key).push.ft07.com/send"
    } else {
        urlString = "https://sctapi.ftqq.com/\(key).send"
    }
    
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return ""
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    let postdata = "text=\(text)&desp=\(desp)"
    request.httpBody = postdata.data(using: .utf8)
    
    let semaphore = DispatchSemaphore(value: 0)
    var result = ""
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
        } else if let data = data {
            result = String(data: data, encoding: .utf8) ?? ""
        }
        semaphore.signal()
    }
    task.resume()
    semaphore.wait()
    
    return result
}

let data = try! String(contentsOfFile: "\(FileManager.default.currentDirectoryPath)/../.env", encoding: .utf8)
let lines = data.components(separatedBy: .newlines)
var key = ""
for line in lines {
    if line.hasPrefix("SENDKEY=") {
        key = line.replacingOccurrences(of: "SENDKEY=", with: "")
        break
    }
}

let ret = sc_send(text: "主人服务器宕机了", desp: "第一行\n\n第二行", key: key)
print(ret)