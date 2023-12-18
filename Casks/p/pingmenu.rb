cask "pingmenu" do
  version "1.3,2"
  sha256 :no_check

  url "https:github.comkallebooPingMenurawmasterPingMenu.app.zip"
  name "PingMenu"
  desc "Utility that shows the current network latency in the menu bar"
  homepage "https:github.comkallebooPingMenu"

  livecheck do
    url :url
    strategy :extract_plist
  end

  app "PingMenu.app"
end