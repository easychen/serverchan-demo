using System;
using System.IO;
using System.Net.Http;
using System.Text;
using System.Text.RegularExpressions;
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
        // 判断 sendkey 是否以 "sctp" 开头并提取数字部分
        if (key.StartsWith("sctp"))
        {
            var match = Regex.Match(key, @"^sctp(\d+)t");
            if (match.Success)
            {
                var num = match.Groups[1].Value;
                url = $"https://{num}.push.ft07.com/send/{key}.send";
            }
            else
            {
                throw new ArgumentException("Invalid key format for sctp.");
            }
        }
        else
        {
            url = $"https://sctapi.ftqq.com/{key}.send";
        }

        var httpClient = new HttpClient();
        var request = new HttpRequestMessage(HttpMethod.Post, url);
        request.Content = new StringContent(postData, Encoding.UTF8, "application/x-www-form-urlencoded");

        var response = await httpClient.SendAsync(request);
        var responseStream = await response.Content.ReadAsStreamAsync();
        var reader = new StreamReader(responseStream);

        return await reader.ReadToEndAsync();
    }
}