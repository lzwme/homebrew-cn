cask "jdkmon" do
  arch arm: "-aarch64", intel: ""

  version "25.0.0"
  sha256 arm:   "ecfb16867c23bbb02e5166070ac26bbc4880882a338825257e7e0298292d60e7",
         intel: "7c65b5aac50684c0ec317a97b4766ac648029982a40eb4c95cffb809e7147a3c"

  url "https://ghfast.top/https://github.com/HanSolo/JDKMon/releases/download/#{version}/JDKMon-#{version}#{arch}.pkg"
  name "jdkmon"
  desc "Little tool that monitors your installed JDK's and inform you about updates"
  homepage "https://github.com/HanSolo/JDKMon"

  livecheck do
    strategy :github_latest
  end

  pkg "JDKMon-#{version}#{arch}.pkg"

  uninstall pkgutil: "eu.hansolo.fx.jdkmon"
end