cask "tccplus-gui" do
  version "1.0"
  sha256 "aae808c90f4137ff81be2feebcad5cf391928e6c699afca4bfe47a299da44664"

  url "https://ghproxy.com/https://github.com/plessbd/tccplus/releases/download/1.0/tccplus.app.zip"
  name "tccplus"
  desc "Grant/remove accessibility permissions to any app"
  homepage "https://github.com/plessbd/tccplus"

  app "tccplus.app", target: "tccplus-gui.app"
end