cask "pingmenu" do
  version "1.3,2"
  sha256 :no_check

  url "https:github.comkallebooPingMenurawmasterPingMenu.app.zip"
  name "PingMenu"
  desc "Utility that shows the current network latency in the menu bar"
  homepage "https:github.comkallebooPingMenu"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-14", because: :unmaintained

  app "PingMenu.app"

  caveats do
    requires_rosetta
  end
end