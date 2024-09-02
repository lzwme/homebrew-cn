cask "prowlarr" do
  arch arm: "arm64", intel: "x64"

  version "1.23.1.4708"
  sha256 arm:   "a6616fd2faeeaf14087835c62b4097051c2a41084328b4a2e153fbd7b0709bf9",
         intel: "af0bd8ff9bfe8854d481bf1c52c045926d3fb825734d9b9af89e70abeb3655bd"

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