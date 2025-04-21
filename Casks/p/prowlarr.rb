cask "prowlarr" do
  arch arm: "arm64", intel: "x64"

  version "1.34.1.5021"
  sha256 arm:   "b5e63a3f3524fcb3d2600293b774ff6b78762db204e2dd28f5081c5c9a58bd2c",
         intel: "60a8ae9e625b45e7938f80cdf3d2b8d6978344d5c284df22c079ec4e66d937f3"

  url "https:github.comProwlarrProwlarrreleasesdownloadv#{version}Prowlarr.master.#{version}.osx-app-core-#{arch}.zip",
      verified: "github.comProwlarrProwlarr"
  name "Prowlarr"
  desc "Indexer managerproxy for various PVR apps"
  homepage "https:prowlarr.com"

  livecheck do
    url "https:prowlarr.servarr.comv1updatemasterchanges?os=osx&arch=#{arch}"
    strategy :json do |json|
      json.map { |item| item["version"] }
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Prowlarr.app"

  zap trash: "~.configProwlarr"
end