cask "lidarr" do
  version "2.2.5.4141"
  sha256 "38f2e92941ae94f56165c4f6d9f77ad7b8246d2a07229a6173a8c9ceba1bf6d2"

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