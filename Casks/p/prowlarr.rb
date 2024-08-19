cask "prowlarr" do
  arch arm: "arm64", intel: "x64"

  version "1.22.0.4670"
  sha256 arm:   "b8b7e6c44920d2cc1644c64ca1a08e55493d41372b73ecaa143d7ebec57f6ed9",
         intel: "0d071889b8846825af4fb71946dbf4ad1de45002af6987f389c6bbbd2185b4ea"

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