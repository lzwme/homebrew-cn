# 🍡 lzwme/homebrew-cn

适合中国大陆用户使用的 [Homebrew](https://brew.sh) 应用代理镜像库。

本仓库主要从多个开源仓库同步更新，保留安装文件在 Github release 等外网下载慢的应用，并将从 `github release` 下载的应用地址修改为基于 `ghporxy.com` 的代理下载地址。

## Usage

```bash
# 添加当前仓库源
brew tap lzwme/cn

# 搜索某个应用
brew search switchhosts

# 从 lzwme/homebrew-cn 仓库安装应用
brew install lzwme/cn/switchhosts

# 也可以一次性从 rb 应用文件安装 (后续若有更新也只能手动检查判断)
brew install https://ghproxy.com/github.com/lzwme/homebrew-cn/blob/main/Formula/<formula>.rb
```

## 国内 Macbook 安装与配置 Homebrew 参考

执行如下命令进行安装和配置：

```bash
# 安装 Homebrew
/bin/bash -c "$(curl -fsSL https://ghproxy.com/raw.githubusercontent.com/lzwme/homebrew-cn/HEAD/install.sh)"

# 添加 `lzwme/homebrew-cn` 仓库源
brew tap lzwme/cn

# 设置环境变了，指定二进制预编译包使用阿里云镜像
# https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles 也可设置为清华源
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles' >> ~/.bash_profile
source ~/.bash_profile

# 更新
brew update
```

## Sync From

- [Homebrew/homebrew-core](https://github.com/Homebrew/homebrew-core)
- [Homebrew/homebrew-cask](https://github.com/Homebrew/homebrew-cask)
- [Homebrew/homebrew-cask-fonts](https://github.com/Homebrew/homebrew-cask-fonts)
- [Homebrew/homebrew-cask-versions](https://github.com/Homebrew/homebrew-cask-versions)
- [Homebrew/homebrew-cask-drivers](https://github.com/Homebrew/homebrew-cask-drivers)

## 声明

本仓库包含的应用信息仅从第三方仓库同步，未逐一作可用性、安全性验证，请在安装选择时自行验证识别。若有侵权请提 issues 处理。
