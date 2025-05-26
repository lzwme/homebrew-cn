cask "font-mynaui-icons" do
  version "0.3.5"
  sha256 "3938799f12f1df3184c223a1784cccc57a90ca082bd23490cfdbe66e12a30e1e"

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