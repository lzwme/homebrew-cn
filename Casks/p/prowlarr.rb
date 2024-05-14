cask "prowlarr" do
  arch arm: "arm64", intel: "x64"

  version "1.17.2.4511"
  sha256 arm:   "faa595640d63481c6afc23f2729e2ee37bece14ffefe59ae5c8284d13982dc92",
         intel: "bf6dbafa85bc59161e66a83872c23a57f26bd3f05739870dd23df5146760ad42"

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