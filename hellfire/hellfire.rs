use reqwest::{Client, Method};
use std::env;
use std::process;
use std::time::{Duration};

// ANSI color codes with bold
const RESET: &str = "\x1b[0m";
const GREEN: &str = "\x1b[1m\x1b[32m";  // Bold and Green
const YELLOW: &str = "\x1b[1m\x1b[33m"; // Bold and Yellow
const RED: &str = "\x1b[1m\x1b[31m";    // Bold and Red
const MAGENTA: &str = "\x1b[1m\x1b[35m"; // Bold and Magenta

fn colorize_status_code(status: u16) -> &'static str {
    match status {
        200..=299 => GREEN,    // 2xx: Success -> Green
        300..=399 => YELLOW,   // 3xx: Redirection -> Yellow
        400..=499 => RED,      // 4xx: Client Errors -> Red
        500..=599 => MAGENTA,  // 5xx: Server Errors -> Magenta
        _ => RESET,            // Default: No color
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = env::args().collect();

    // Check if exactly 2 arguments are passed (program name and URL)
  if args.len() != 2 {
        eprintln!("\x1b[1;37mUsage: ./hellfire <url>");
        process::exit(1);  // Exit with a non-zero code to indicate failure
    }

    let url = &args[1];

    let client = Client::builder()
        .connect_timeout(Duration::from_secs(5))
        .timeout(Duration::from_secs(10))
        .build()?;

    let methods = [
        "GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS", "PATCH", "TRACE", "CONNECT",
        "PROPFIND", "PROPPATCH", "MKCOL", "COPY", "MOVE", "LOCK", "UNLOCK", "REPORT",
        "MKACTIVITY", "CHECKOUT", "MERGE", "SEARCH", "PURGE", "LINK", "UNLINK"
    ];

    println!("|\x1b[1m[Testing For Verb Tampering]");

    for method_str in methods.iter() {
        let method = Method::from_bytes(method_str.as_bytes())?;
        let response = client.request(method, url).send().await?;
        let status = response.status().as_u16();
        
        // Print the status code with the corresponding color and reset it after printing
        let color = colorize_status_code(status);

        println!("|{}{} {}{}", color, status, method_str, RESET);
    }

    Ok(())
}
