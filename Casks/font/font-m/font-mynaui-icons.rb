cask "font-mynaui-icons" do
  version "0.3.9"
  sha256 "48bf58a511ed434843f5b597a2692f99c15e26e3838f2383e0e81f6add5287c4"

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