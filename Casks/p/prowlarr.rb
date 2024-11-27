cask "prowlarr" do
  arch arm: "arm64", intel: "x64"

  version "1.27.0.4852"
  sha256 arm:   "3bf4a27d3de8bcdcc30cbe7951f5d49e9902395f62dda0ace9fd2e4e31896b04",
         intel: "261299d5465b3ad14bf62516091c48d2cd442af0930aba0e9bdcdee546857542"

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