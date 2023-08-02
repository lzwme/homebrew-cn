cask "tccplus-gui" do
  version "1.0"
  sha256 :no_check

  url "https://ghproxy.com/https://github.com/plessbd/tccplus/releases/download/1.0/tccplus.app.zip"
  name "tccplus"
  desc "Grant/remove accessibility permissions to any app"
  homepage "https://github.com/plessbd/tccplus"

  app "tccplus.app", target: "tccplus-gui.app"
end