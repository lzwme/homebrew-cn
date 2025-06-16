cask "radarr" do
  arch arm: "arm64", intel: "x64"

  version "5.26.2.10099"
  sha256 arm:   "55270df5fd11da251a8f6f2fed81a5225469aef016fe159ee7122bcd08a3d023",
         intel: "21cdf83b5bace83bc69cd6919f2ca39270e8231ecfe3a351ba387fec4ae1eff0"

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