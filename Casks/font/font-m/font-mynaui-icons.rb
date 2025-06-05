cask "font-mynaui-icons" do
  version "0.3.7"
  sha256 "46e21c2d194e3416f667b0777e416472f0f8a4729fdbc901bd0b5cb00df573d4"

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