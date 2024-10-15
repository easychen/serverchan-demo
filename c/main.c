#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>

#define MAX_BUFFER_SIZE 1024

// gcc -o main main.c -lcurl

typedef struct {
    char* text;
    char* desp;
    char* key;
} SCData;

size_t write_callback(void* contents, size_t size, size_t nmemb, char* buffer) {
    size_t total_size = size * nmemb;
    strncat(buffer, contents, total_size);
    return total_size;
}

void sc_send(SCData* data) {
    CURL* curl;
    CURLcode res;
    char url[MAX_BUFFER_SIZE];
    char post_data[MAX_BUFFER_SIZE];
    char response[MAX_BUFFER_SIZE];

    curl_global_init(CURL_GLOBAL_DEFAULT);
    curl = curl_easy_init();
    if (curl) {
        // 判断 sendkey 是否以 "sctp" 开头，并提取后续数字
        if (strncmp(data->key, "sctp", 4) == 0) {
            int num;
            if (sscanf(data->key, "sctp%dt", &num) == 1) {
                snprintf(url, MAX_BUFFER_SIZE, "https://%d.push.ft07.com/send/%s.send", num, data->key);
            } else {
                fprintf(stderr, "Invalid sendkey format for sctp\n");
                curl_easy_cleanup(curl);
                curl_global_cleanup();
                return;
            }
        } else {
            snprintf(url, MAX_BUFFER_SIZE, "https://sctapi.ftqq.com/%s.send", data->key);
        }
        
        snprintf(post_data, MAX_BUFFER_SIZE, "text=%s&desp=%s", data->text, data->desp);

        curl_easy_setopt(curl, CURLOPT_URL, url);
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, post_data);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, response);

        res = curl_easy_perform(curl);
        if (res != CURLE_OK) {
            fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
        }

        curl_easy_cleanup(curl);
    }

    curl_global_cleanup();

    printf("%s\n", response);
}

int main() {
    char* dotenv_path = "../.env";
    char* sendkey = NULL;
    FILE* dotenv_file = fopen(dotenv_path, "r");
    if (dotenv_file) {
        char line[MAX_BUFFER_SIZE];
        while (fgets(line, sizeof(line), dotenv_file)) {
            char* key = strtok(line, "=");
            char* value = strtok(NULL, "=");
            if (strcmp(key, "SENDKEY") == 0) {
                sendkey = strdup(value);
                break;
            }
        }
        fclose(dotenv_file);
    }

    if (sendkey) {
        SCData data;
        data.text = "主人服务器宕机了 via c";
        data.desp = "第一行\n\n第二行";
        data.key = sendkey;

        sc_send(&data);

        free(sendkey);
    }

    return 0;
}