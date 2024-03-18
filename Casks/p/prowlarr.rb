cask "prowlarr" do
  arch arm: "arm64", intel: "x64"

  version "1.14.3.4333"
  sha256 arm:   "97cfc44e1bbabacef48e9d434b0abe22ae2250a5822f38e7cd73c1ccc695f1e8",
         intel: "9a0641e16af5e06aa1fda784c45ee2ceb4f4f6d82eabefb29120384652de3719"

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