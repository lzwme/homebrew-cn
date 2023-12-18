cask "iptvnator" do
  version "0.15.0"
  sha256 "b08c25e7755b00cf2c7d840992bf7e94e39200eb7950641b6714a6976e02a2af"

  url "https:github.com4grayiptvnatorreleasesdownloadv#{version}IPTVnator-#{version}-universal.dmg"
  name "IPTVnator"
  desc "Open Source m3u, m3u8 player"
  homepage "https:github.com4grayiptvnator"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "iptvnator.app"

  zap trash: [
    "~LibraryApplication Supportiptvnator",
    "~LibraryPreferencescom.electron.iptvnator.plist",
    "~LibrarySaved Application Statecom.electron.iptvnator.savedState",
  ]
end