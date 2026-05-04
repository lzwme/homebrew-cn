cask "font-lxgw-neoxihei" do
  version "1.300"
  sha256 "9f96f9b189a7dd7fc4a388f0c2de06ffa375ee25413ee716d0a4e53ff33e5dc7"

  url "https://ghfast.top/https://github.com/lxgw/LxgwNeoXiHei/releases/download/v#{version}/LXGWNeoXiHei.ttf"
  name "LXGW NeoXiHei"
  name "霞鹜新晰黑"
  homepage "https://github.com/lxgw/LxgwNeoXiHei"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "LXGWNeoXiHei.ttf"

  # No zap stanza required
end