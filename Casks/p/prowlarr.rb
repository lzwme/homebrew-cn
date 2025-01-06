cask "prowlarr" do
  arch arm: "arm64", intel: "x64"

  version "1.29.2.4915"
  sha256 arm:   "661600462e77019323ab678bda900ed3c620ded67bbc2d1f516fb6856564302e",
         intel: "2cf0f37117574e4139615023b179ee78730e9345c7944c93ec94f6788b563f20"

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