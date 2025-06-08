cask "font-mynaui-icons" do
  version "0.3.8"
  sha256 "8ca072f090625455b3b9c22c39b46887c9be96accda9539f49a1cb512e9209bd"

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