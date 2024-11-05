cask "jdkmon" do
  arch arm: "-aarch64", intel: ""

  version "21.0.7"
  sha256 arm:   "6df912ab075cc7fcaf1550dd2ec68c33b5535f7e7cc1a209af6b96b087b387f3",
         intel: "8712e97eb884c62ec900189e09efed1431634daa6a6bdd2d6fad16ffcecbf216"

  url "https:github.comHanSoloJDKMonreleasesdownload#{version}JDKMon-#{version}#{arch}.pkg"
  name "jdkmon"
  desc "Little tool that monitors your installed JDK's and inform you about updates"
  homepage "https:github.comHanSoloJDKMon"

  livecheck do
    strategy :github_latest
  end

  pkg "JDKMon-#{version}#{arch}.pkg"

  uninstall pkgutil: "eu.hansolo.fx.jdkmon"
end