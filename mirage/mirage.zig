const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    
    if (args.len != 3)
    { std.debug.print("\x1b[1;37mUsage: ./mirage <IP> <DOMAIN>", .{}); }
    else
    {
     const target = args[1];
     const domain_name = args[2];
     
std.debug.print("\x1b[1;38;5;49m[Information Gathering]\x1b[1;38;5;34m\n\nnmap -sVC -Pn {s}\nnmap -sVC -Pn -p- {s}\nsudo nmap -T4 -sU -Pn {s}\n\nffuf -w STW_20k.txt:FUZZ -u http://{s}/ -H 'Host: FUZZ.{s}' -ac\nffuf -w STW_100k.txt:FUZZ -u http://{s}/ -H 'Host: FUZZ.{s}' -ac\nffuf -w STW_bitquark_100k.txt:FUZZ -u http://{s}/ -H 'Host: FUZZ.{s}' -ac\n\nferoxbuster -k --auto-tune -u http://{s}/\nferoxbuster -r -k -E -g -C 400,403,404 --auto-tune -u http://{s}/\nferoxbuster -r -k -E -g -C 400,403,404,500,502,503 --auto-tune -u http://{s}/\n\nwhatweb -a 3 {s}\nwafw00f -a http://{s}/\n\n\x1b[1;38;5;226m[Misc]\x1b[1;38;5;178m\n\nnc -lvnp 4444\npython3 -m http.server 7000\npython3 -c 'import pty; pty.spawn(\"/bin/bash\")'\necho \"{s} {s}\" | sudo tee -a /etc/hosts\n\n\x1b[1;38;5;87m[SSTI Payloads]\x1b[1;38;5;33m\n\n${{7*7}}\na{{*comment*}}b\n${{\"z\".join(\"ab\")}}\n\n{{{{7*7}}}}\n{{{{7*'7'}}}}", .{target, target, target, target, domain_name, target, domain_name, target, domain_name, domain_name, domain_name, domain_name, target, domain_name, target, domain_name});
    }
}
