cask "radarr" do
  arch arm: "arm64", intel: "x64"

  version "5.23.3.9987"
  sha256 arm:   "fe65f5bfc5da3168de61a66cba10d6688bf1c9aaf9f5fda1364fe3c2d16ba636",
         intel: "ac5eca5c97944a0c536a44b8d2ae36579c3a73dad458f0762be3d969754aed10"

  url "https:github.comRadarrRadarrreleasesdownloadv#{version}Radarr.master.#{version}.osx-app-core-#{arch}.zip",
      verified: "github.comRadarrRadarr"
  name "Radarr"
  desc "Fork of Sonarr to work with movies à la Couchpotato"
  homepage "https:radarr.video"

  livecheck do
    url "https:radarr.servarr.comv1updatemasterchanges?os=osx&arch=#{arch}"
    strategy :json do |json|
      json.map { |item| item["version"] }
    end
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Radarr.app"

  zap trash: "~.configRadarr"
end