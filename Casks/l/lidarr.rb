cask "lidarr" do
  version "2.6.4.4402"
  sha256 "5c5b7b111803f4447adbab80e6d4b2d28126094ec5459d39760648e9300af698"

  url "https:github.comlidarrLidarrreleasesdownloadv#{version}Lidarr.master.#{version}.osx-app-core-x64.zip",
      verified: "github.comlidarrLidarr"
  name "Lidarr"
  desc "Looks and smells like Sonarr but made for music"
  homepage "https:lidarr.audio"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Lidarr.app"

  zap trash: "~.configLidarr"

  caveats do
    requires_rosetta
  end
end