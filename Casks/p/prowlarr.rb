cask "prowlarr" do
  arch arm: "arm64", intel: "x64"

  version "1.24.3.4754"
  sha256 arm:   "6aa6b1362647b5efd54c153911c59e38d014a75b50484feeb491d2f0e3a711d2",
         intel: "dc3f0832457b822b7e6e28dc13fb1500cfa435dc31f5ceecdc07b5fde0460976"

  url "https:github.comProwlarrProwlarrreleasesdownloadv#{version}Prowlarr.master.#{version}.osx-app-core-#{arch}.zip",
      verified: "github.comProwlarrProwlarr"
  name "Prowlarr"
  desc "Indexer managerproxy for various PVR apps"
  homepage "https:prowlarr.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Prowlarr.app"

  zap trash: "~.configProwlarr"
end