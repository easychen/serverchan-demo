import java.io.FileInputStream;
import java.io.IOException;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Properties;
import java.util.regex.*;

public class Main {

    public static void main(String[] args) {
        Properties data = parseIniFile("../.env");
        String key = data.getProperty("SENDKEY");

        String ret = scSend("主人服务器宕机了 via java", "第一行\n\n第二行", key);
        System.out.println(ret);
    }

    public static Properties parseIniFile(String filePath) {
        Properties properties = new Properties();
        try {
            properties.load(new FileInputStream(filePath));
        } catch (IOException e) {
            e.printStackTrace();
        }
        return properties;
    }

    public static String scSend(String var0, String var1, String var2) {
        try {
            String var3;

            // 判断 sendkey 是否以 "sctp" 开头，并提取数字部分拼接 URL
            if (var2.startsWith("sctp")) {
                Pattern pattern = Pattern.compile("sctp(\\d+)t");
                Matcher matcher = pattern.matcher(var2);
                if (matcher.find()) {
                    String num = matcher.group(1);
                    var3 = "https://" + num + ".push.ft07.com/send/" + var2 +".send";
                } else {
                    throw new IllegalArgumentException("Invalid sendkey format for sctp");
                }
            } else {
                var3 = "https://sctapi.ftqq.com/" + var2 + ".send";
            }
    
            String var10000 = URLEncoder.encode(var0, "UTF-8");
            String var4 = "text=" + var10000 + "&desp=" + URLEncoder.encode(var1, "UTF-8");
            URL var5 = new URL(var3);
            HttpURLConnection var6 = (HttpURLConnection) var5.openConnection();
            var6.setRequestMethod("POST");
            var6.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            var6.setDoOutput(true);
            DataOutputStream var7 = new DataOutputStream(var6.getOutputStream());
            var7.writeBytes(var4);
            var7.flush();
            var7.close();
            int var8 = var6.getResponseCode();
            BufferedReader var9 = new BufferedReader(new InputStreamReader(var6.getInputStream()));
            StringBuilder var11 = new StringBuilder();
    
            String var10;
            while ((var10 = var9.readLine()) != null) {
                var11.append(var10);
            }
    
            var9.close();
            return var11.toString();
        } catch (Exception var12) {
            var12.printStackTrace();
            return null;
        }
    }
    
}