cask "font-lxgw-fasmartgothic" do
  version "1.201"
  sha256 "46c06f85c75aa55b4450fa02c37a35f0f8a4efe8058ffcb6e48b9e2eccd764eb"

  url "https://ghfast.top/https://github.com/lxgw/LxgwFasmartGothic/releases/download/v#{version}/LXGWFasmartGothic.ttf"
  name "LXGW FasmartGothic"
  name "霞鹜尚智黑"
  homepage "https://github.com/lxgw/LxgwNeoXiHei"

  deprecate! date: "2024-11-22", because: :discontinued

  font "LXGWFasmartGothic.ttf"

  # No zap stanza required
end