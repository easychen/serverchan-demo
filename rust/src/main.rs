use std::env;
use reqwest::header::{CONTENT_TYPE, CONTENT_LENGTH};
use serde_urlencoded;
use tokio;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    dotenv::dotenv().ok();
    let key = env::var("SENDKEY").unwrap();
    let ret = sc_send("主人服务器宕机了".to_string(), "第一行\n\n第二行".to_string(), key).await?;
    println!("{}", ret);
    Ok(())
}

async fn sc_send(text: String, desp: String, key: String) -> Result<String, Box<dyn std::error::Error>> {
    let params = [("text", text), ("desp", desp)];
    let post_data = serde_urlencoded::to_string(params)?;
    // 修改 URL 拼接逻辑
    let url = if key.starts_with("sctp") {
        format!("https://{}.push.ft07.com/send", key)
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