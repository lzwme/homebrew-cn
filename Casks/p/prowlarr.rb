cask "prowlarr" do
  arch arm: "arm64", intel: "x64"

  version "1.36.3.5071"
  sha256 arm:   "ab9747e7917376942c6ca1d64a85b7fbcdc7314e3deff7379973af07a623a5fb",
         intel: "0a1532ccdf628c6a1df01e852e02fd095d9f759c91bbc68e9c6073889500e357"

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