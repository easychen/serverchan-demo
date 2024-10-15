use std::env;
use reqwest::header::{CONTENT_TYPE, CONTENT_LENGTH};
use serde_urlencoded;
use tokio;
use regex::Regex;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    dotenv::dotenv().ok();
    let key = env::var("SENDKEY").unwrap();
    let ret = sc_send("主人服务器宕机了 via Rust".to_string(), "第一行\n\n第二行".to_string(), key).await?;
    println!("{}", ret);
    Ok(())
}

async fn sc_send(text: String, desp: String, key: String) -> Result<String, Box<dyn std::error::Error>> {
    let params = [("text", text), ("desp", desp)];
    let post_data = serde_urlencoded::to_string(params)?;
    // 使用正则表达式提取 key 中的数字部分
    let url = if key.starts_with("sctp") {
        let re = Regex::new(r"sctp(\d+)t")?;
        if let Some(captures) = re.captures(&key) {
            let num = &captures[1]; // 提取正则表达式捕获的数字部分
            format!("https://{}.push.ft07.com/send/{}.send", num, key)
        } else {
            return Err("Invalid sendkey format for sctp".into());
        }
    } else {
        format!("https://sctapi.ftqq.com/{}.send", key)
    };
    let client = reqwest::Client::new();
    let res = client.post(&url)
        .header(CONTENT_TYPE, "application/x-www-form-urlencoded")
        .header(CONTENT_LENGTH, post_data.len() as u64)
        .body(post_data)
        .send()
        .await?;
    let data = res.text().await?;
    Ok(data)
}