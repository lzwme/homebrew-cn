cask "lidarr" do
  arch arm: "arm64", intel: "x64"

  version "2.12.4.4658"
  sha256 arm:   "6ccd80bb17ecb155762d3ff2a278d9ee4c1e347b4da07f34c1af431a36b38a95",
         intel: "27a5d313d6ac4777a2274454d96eb28469f212a54cf50de9c7a7b26632bc6ad2"

  url "https:github.comlidarrLidarrreleasesdownloadv#{version}Lidarr.master.#{version}.osx-app-core-#{arch}.zip",
      verified: "github.comlidarrLidarr"
  name "Lidarr"
  desc "Looks and smells like Sonarr but made for music"
  homepage "https:lidarr.audio"

  livecheck do
    url "https:lidarr.servarr.comv1updatemasterchanges?os=osx&arch=#{arch}"
    strategy :json do |json|
      json.map { |item| item["version"] }
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Lidarr.app"

  zap trash: "~.configLidarr"
end