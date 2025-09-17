cask "jdkmon" do
  arch arm: "-aarch64", intel: ""

  version "21.0.17"
  sha256 arm:   "2b1d3c4469dee04cbb3c306f1cc5fddc259287af0c18ee1a3de543597da4fc7f",
         intel: "b1263210c0ef1ae5a1a7573fae784699071da9c15656cc7e178553d848642d7a"

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