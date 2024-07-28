cask "jdkmon" do
  arch arm: "-aarch64", intel: ""

  version "21.0.5"
  sha256 arm:   "c2aebe13baf22532eb99f0b475b86f7883e6596cf1e770718a35a0cb1f171abe",
         intel: "675f65122a48267fa81642fcf26f26abc7c22b59c52c50d8e6eddd615f5279fd"

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