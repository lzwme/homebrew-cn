cask "font-mynaui-icons" do
  version "0.3.1"
  sha256 "d041b409035092bbbf69e86c1f61b4bc3049d11856365ce747edd67838675415"

  url "https:github.compraveenjugemynaui-iconsarchiverefstagsv#{version}.tar.gz",
      verified: "github.compraveenjugemynaui-icons"
  name "MynaUI Icons"
  homepage "https:mynaui.comicons"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "mynaui-icons-#{version}packagesiconsmynaui-solid.ttf"
  font "mynaui-icons-#{version}packagesiconsmynaui.ttf"

  # No zap stanza required
end