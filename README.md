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
brew install https://ghproxy/raw.githubusercontent.com/lzwme/homebrew-cn/main/Formula/<formula>.rb
```

## 国内 Macbook 安装与配置 Homebrew 参考

执行如下命令进行安装：

```bash
# 安装 Homebrew


# 添加 `lzwme/homebrew-cn` 仓库源
brew tap lzwme/cn

# todo: 设置...
```

## Sync From

- [Homebrew/homebrew-core](https://github.com/Homebrew/homebrew-core)
- [Homebrew/homebrew-cask](https://github.com/Homebrew/homebrew-cask)
- [Homebrew/homebrew-cask-fonts](https://github.com/Homebrew/homebrew-cask-fonts)
- [Homebrew/homebrew-cask-versions](https://github.com/Homebrew/homebrew-cask-versions)
- [Homebrew/homebrew-cask-drivers](https://github.com/Homebrew/homebrew-cask-drivers)

## 声明

本仓库包含的应用信息仅从第三方仓库同步，未逐一作可用性、安全性验证，请在安装选择时自行验证识别。若有侵权请提 issues 处理。
