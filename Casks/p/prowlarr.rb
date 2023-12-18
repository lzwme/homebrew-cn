cask "prowlarr" do
  arch arm: "arm64", intel: "x64"

  version "1.10.5.4116"
  sha256 arm:   "406a355bda7ce919c271e23e447e54e41fdf49e20929acfb7dbf0bb7eef29eb5",
         intel: "662629c63f96f41858d01ec636943485d9e62d327a1442608b5aa0c5f7469b68"

  url "https:github.comProwlarrProwlarrreleasesdownloadv#{version}Prowlarr.master.#{version}.osx-app-core-#{arch}.zip",
      verified: "github.comProwlarrProwlarr"
  name "Prowlarr"
  desc "Indexer managerproxy for various PVR apps"
  homepage "https:prowlarr.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Prowlarr.app"

  zap trash: "~.configProwlarr"
end