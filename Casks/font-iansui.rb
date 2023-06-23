cask "font-iansui" do
  version "1.000"
  sha256 "f58add84ad60d5bbeec4b1e7b988f0fe19ec980d953cf7e67c8f2ea783e2fe38"

  url "https://ghproxy.com/https://github.com/ButTaiwan/iansui/releases/download/v#{version}/iansui.zip"
  name "iansui"
  desc "Chinese font derived from Klee One"
  homepage "https://github.com/ButTaiwan/iansui"

  font "Iansui-Regular.ttf"
end