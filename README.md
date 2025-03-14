# Nginx + Trojan Proxy with Disguised Website (Docker)

这是一个基于Docker的Nginx + Trojan代理服务器解决方案，带有伪装网站（PDF工具网站）。整个服务通过SSL加密，使用ACME客户端自动管理和更新SSL证书。

## 特点

- 完全基于Docker，易于部署
- 使用Nginx作为Web服务器和前端代理
- 集成Trojan代理服务，提供安全的代理功能
- 包含一个精美的PDF工具网站作为伪装
- 自动通过ACME申请和更新SSL证书
- 所有关键参数（域名、端口、密码等）都可配置

## 系统要求

- 一个运行Debian/Ubuntu的服务器
- Docker 和 Docker Compose 已安装
- 一个指向服务器IP的域名

## 安装步骤

### 1. 克隆仓库

```bash
git clone https://github.com/yourusername/nginx-trojan-docker.git
cd nginx-trojan-docker
```

### 2. 配置参数

编辑`.env`文件，设置以下参数：

```bash
# 基本设置
DOMAIN=你的域名.com
EMAIL=你的邮箱@example.com

# Web服务器设置
HTTP_PORT=80
HTTPS_PORT=443

# Trojan设置
TROJAN_PASSWORD=你的强密码
TROJAN_REMOTE_ADDR=127.0.0.1
TROJAN_REMOTE_PORT=80
```

### 3. 申请SSL证书

运行初始化证书脚本：

```bash
./init-cert.sh
```

这将自动申请SSL证书并配置到正确的位置。

### 4. 启动服务

```bash
./start.sh
```

服务启动后，可以通过以下方式访问：

- **网站**: `https://你的域名.com`
- **Trojan代理**: 在客户端配置中使用`你的域名.com:443`作为服务器地址，密码为你在`.env`中设置的`TROJAN_PASSWORD`

## 客户端配置示例

### Trojan客户端配置（Windows/macOS/iOS/Android）

```json
{
    "run_type": "client",
    "local_addr": "127.0.0.1",
    "local_port": 1080,
    "remote_addr": "你的域名.com",
    "remote_port": 443,
    "password": ["你设置的TROJAN_PASSWORD"],
    "log_level": 1,
    "ssl": {
        "verify": true,
        "verify_hostname": true,
        "cert": "",
        "cipher": "",
        "cipher_tls13": "",
        "sni": "",
        "alpn": [
            "h2",
            "http/1.1"
        ],
        "reuse_session": true,
        "session_ticket": false,
        "curves": ""
    },
    "tcp": {
        "no_delay": true,
        "keep_alive": true,
        "reuse_port": false,
        "fast_open": false,
        "fast_open_qlen": 20
    }
}
```

## 更新SSL证书

证书会通过ACME容器自动更新。如果需要手动更新，可以运行：

```bash
docker-compose run --rm acme --renew -d $DOMAIN --force
```

## 目录结构

```
nginx-trojan-docker/
├── acme/                   # ACME客户端数据目录
├── conf.d/                 # Nginx配置文件
│   └── default.conf        # 网站和代理配置
├── nginx/                  # Nginx主配置
│   └── nginx.conf          # Nginx主配置文件
├── ssl/                    # SSL证书存储
├── trojan/                 # Trojan配置
│   └── config.json         # Trojan配置文件
├── website/                # 伪装网站文件
│   └── index.html          # PDF工具网站HTML
├── .env                    # 环境变量配置
├── docker-compose.yml      # Docker Compose配置
├── init-cert.sh            # 证书初始化脚本
├── start.sh                # 服务启动脚本
└── README.md               # 项目说明文档
```

## 安全注意事项

- 请务必修改默认的Trojan密码
- 建议定期更换Trojan密码以提高安全性
- 确保服务器防火墙只开放80和443端口

## 故障排除

如果遇到问题，可以查看Docker日志：

```bash
docker-compose logs nginx
docker-compose logs trojan
docker-compose logs acme
```

## 许可证

MIT

---

注意：此项目仅用于学习和研究网络技术，请遵守当地法律法规使用。 