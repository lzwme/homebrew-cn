cask "jdkmon" do
  arch arm: "-aarch64", intel: ""

  version "17.0.81"
  sha256 arm:   "1b597eacefbed79b03d2554e146fb56b1fbab5855d799966f18c64debc4809e8",
         intel: "9ddca636a7cfd3ddbf570b0cc6703483262ad3afa85f2c6dd2d2b2f56de3a8fa"

  url "https://ghproxy.com/https://github.com/HanSolo/JDKMon/releases/download/#{version}/JDKMon-#{version}#{arch}.pkg"
  name "jdkmon"
  desc "Little tool that monitors your installed JDK's and inform you about updates"
  homepage "https://github.com/HanSolo/JDKMon"

  pkg "JDKMon-#{version}#{arch}.pkg"

  uninstall pkgutil: "eu.hansolo.fx.jdkmon"
end