cask "lidarr" do
  version "2.3.3.4204"
  sha256 "54bd465130edf1d42fc08d37f1ece641166054c9190ee03e6cf9894c6adee790"

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
end