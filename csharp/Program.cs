using System;
using System.IO;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

class Program
{
    static async Task Main(string[] args)
    {
        string data = File.ReadAllText(Path.Combine(Directory.GetCurrentDirectory(), "../.env"));
        var key = data.Split('=')[1].Trim();

        var ret = await ScSend("主人服务器宕机了", "第一行\n\n第二行", key);
        Console.WriteLine(ret);
    }

    static async Task<string> ScSend(string text, string desp = "", string key = "[SENDKEY]")
    {
        var postData = $"text={Uri.EscapeDataString(text)}&desp={Uri.EscapeDataString(desp)}";
         // 根据 sendkey 的前缀选择不同的 API URL
        var url = key.StartsWith("sctp") 
            ? $"https://{key}.push.ft07.com/send" 
            : $"https://sctapi.ftqq.com/{key}.send";

        var httpClient = new HttpClient();
        var request = new HttpRequestMessage(HttpMethod.Post, url);
        request.Content = new StringContent(postData, Encoding.UTF8, "application/x-www-form-urlencoded");

        var response = await httpClient.SendAsync(request);
        var responseStream = await response.Content.ReadAsStreamAsync();
        var reader = new StreamReader(responseStream);

        return await reader.ReadToEndAsync();
    }
}