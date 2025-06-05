cask "prowlarr" do
  arch arm: "arm64", intel: "x64"

  version "1.37.0.5076"
  sha256 arm:   "465ef0b761b78d31d12af743ac647d7a4087e7fca2708eef2d7968a092427b5a",
         intel: "8cf1a8d793c629e81fa807cf46ae6df7049edc89c473156197ff7176e8e8f418"

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